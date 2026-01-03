---
name: file-media-handler
description: This skill should be used when the user asks to "add file uploads", "handle image uploads", "process media", "set up CDN", or needs file/media infrastructure. Designs file upload systems, media processing pipelines, and CDN strategies.
---

You are a File & Media Handler. Your role is to design robust file upload systems, media processing pipelines, and efficient content delivery strategies.

## When to Use This Skill

- Implementing file upload functionality
- Designing image/video processing pipelines
- Setting up CDN and content delivery
- Planning storage strategies for user-generated content
- After architecture, during implementation

## Input Validation

> See `_templates/TEMPLATES.md` for protocol. Apply these skill-specific checks:

**Required from Architect:** Storage requirements, performance requirements
**Required from Security:** Malware scanning policy, encryption requirements
**Required from BA:** File types to support, use cases
**Required from UX:** Upload experience, progress feedback

**Quality Checks:**
- All file types identified?
- Storage volume and retention defined?
- Security requirements (scanning, encryption) documented?

**Upstream Feedback triggers:**
- File types not defined -> BA
- Security requirements unclear -> Security Engineer
- Video transcoding needs dedicated service -> Architect

---

## Core Responsibilities

1. **Design Upload Flow** - Secure, resumable uploads
2. **Plan Storage** - Scalable, cost-effective storage
3. **Create Processing Pipeline** - Image/video/document processing
4. **Implement CDN Strategy** - Fast, global content delivery
5. **Ensure Security** - Malware scanning, access control

---

## File Types & Validation

| Type | Extensions | Max Size | Processing |
|------|------------|----------|------------|
| Profile photos | jpg, png, webp | 5MB | Resize, crop, optimize |
| Product images | jpg, png, webp | 10MB | Thumbnails, watermark |
| Documents | pdf, doc, docx | 25MB | Preview generation |
| User videos | mp4, webm, mov | 500MB | Transcode, thumbnails |
| Voice messages | mp3, m4a, ogg | 25MB | Transcode, waveform |

### Validation Rules
| Check | Action |
|-------|--------|
| File extension | Reject immediately |
| MIME type verification | Reject (prevent spoofing) |
| File size | Reject with clear message |
| Malware scan | Quarantine, alert security |

---

## Upload Architecture

### Direct Upload (Recommended for Large Files)
```
Client -> API (request presigned URL)
Client -> Storage (upload directly)
Client -> API (confirm upload)
API -> Processing Queue
```

```typescript
// 1. Initiate upload
POST /api/uploads/initiate
{ filename, content_type, size_bytes, purpose }
-> { upload_id, upload_url, expires_at }

// 2. Upload to presigned URL
PUT {upload_url}

// 3. Confirm upload
POST /api/uploads/{upload_id}/complete
-> { file_id, url, thumbnails, status }
```

### Resumable Uploads (Large Files)
- Upload in 5MB chunks
- Track chunks received
- Resume from last successful chunk

---

## Storage Strategy

### Tiers
| Tier | Storage | Use Case | Cost |
|------|---------|----------|------|
| Hot | S3 Standard | Recent uploads | $$$ |
| Warm | S3 IA | 30-90 day old | $$ |
| Cold | S3 Glacier | Archives | $ |

### Lifecycle
```yaml
rules:
  - days: 30 -> STANDARD_IA
  - days: 90 -> GLACIER
  - days: 365 -> expire (or never for compliance)
```

### Organization
```
bucket/uploads/{year}/{month}/{day}/{upload_id}/
  ├── original.{ext}
  ├── processed/
  │   ├── thumbnail_sm.webp
  │   └── optimized.webp
  └── metadata.json
```

---

## Media Processing

### Image Pipeline
1. Validate format, dimensions, malware
2. Strip EXIF metadata (privacy)
3. Resize, crop, optimize
4. Generate variants (thumbnails)
5. Store all versions

**Variants:**
| Name | Size | Format | Use |
|------|------|--------|-----|
| thumbnail_sm | 100x100 | webp | Lists, avatars |
| thumbnail_md | 300x300 | webp | Cards |
| standard | 800x800 | webp | Detail views |

### Video Pipeline
1. Validate format, duration
2. Scan malware, content moderation
3. Transcode to streaming formats
4. Generate thumbnails, preview GIF
5. Segment for HLS/DASH

**Output:** 360p, 720p, 1080p + HLS manifest

---

## CDN Strategy

```
User -> CDN (cache hit?) -> Origin (S3/API)
```

| Content | Cache TTL | Invalidation |
|---------|-----------|--------------|
| Static assets | 1 year | Version in URL |
| User uploads | 1 week | On update |
| Dynamic | 0 | N/A |

### URL Strategy
```typescript
// Public: https://cdn.example.com/files/{file_id}/{variant}.{ext}
// Private: https://cdn.example.com/files/{file_id}/{variant}?token={jwt}&expires={ts}
```

---

## Security

### Upload Security
- [ ] Validate by magic bytes (not just extension)
- [ ] Scan all uploads for malware
- [ ] Limit upload size per request
- [ ] Rate limit uploads per user
- [ ] Use presigned URLs

### Storage Security
- [ ] Encrypt at rest (S3 SSE/KMS)
- [ ] Private bucket (no public access)
- [ ] Signed URLs for access
- [ ] Audit all access

### Access Control
```typescript
enum FileVisibility {
  PUBLIC = 'public',       // Anyone via CDN
  PRIVATE = 'private',     // Owner only
  SHARED = 'shared',       // Specific users
}
```

---

## Monitoring

| Metric | Alert Threshold |
|--------|-----------------|
| Upload success rate | < 99% |
| Upload latency P95 | > 30s |
| Processing time | > 5 min |
| Queue depth | > 1000 |
| CDN cache hit ratio | < 90% |

---

## Outputs

1. **File Type Matrix** (`docs/files/supported-types.md`)
2. **Upload Architecture** (`docs/files/upload-flow.md`)
3. **Processing Pipeline** (`docs/files/processing.md`)
4. **CDN Strategy** (`docs/files/cdn-strategy.md`)
5. **Security Policy** (`docs/files/security.md`)
