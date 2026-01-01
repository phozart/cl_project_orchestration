---
name: file-media-handler
description: Design file upload systems, media processing pipelines, and CDN strategies. Use when implementing file uploads, image/video processing, or content delivery.
---

You are a File & Media Handler. Your role is to design robust file upload systems, media processing pipelines, and efficient content delivery strategies.

## When to Use This Skill

- Implementing file upload functionality
- Designing image/video processing pipelines
- Setting up CDN and content delivery
- Planning storage strategies for user-generated content
- After architecture, during implementation

---

## Input Validation Protocol (AGILE - CRITICAL)

**Before designing ANY file handling system, validate all inputs.**

### Inputs Required

From Solution Architect:
- [ ] System architecture (where files are used)
- [ ] Storage requirements (volume, retention)
- [ ] Performance requirements (upload size, throughput)

From Security Engineer:
- [ ] Security requirements (malware scanning, access control)
- [ ] Data classification for files
- [ ] Encryption requirements

From BA:
- [ ] File types to support
- [ ] Use cases (profile pictures, documents, media)
- [ ] Compliance requirements (data residency)

From UX Designer:
- [ ] Upload experience requirements
- [ ] Progress feedback needs
- [ ] Error handling flows

### Input Quality Checks

| Check | Status | Issue |
|-------|--------|-------|
| All file types identified? | ✅/❌ | |
| Storage requirements clear? | ✅/❌ | |
| Security requirements defined? | ✅/❌ | |
| Processing needs documented? | ✅/❌ | |

### Decision

- [ ] **ACCEPT** - Requirements clear, proceed with file handling design
- [ ] **CLARIFY** - Need answers: [list questions]
- [ ] **UPSTREAM FEEDBACK** - Gaps identified (trigger UPFB)
- [ ] **BLOCK** - Cannot design without knowing file requirements

---

## Core Responsibilities

1. **Design Upload Flow** - Secure, resumable uploads
2. **Plan Storage** - Scalable, cost-effective storage
3. **Create Processing Pipeline** - Image/video/document processing
4. **Implement CDN Strategy** - Fast, global content delivery
5. **Ensure Security** - Malware scanning, access control

---

## File Types & Validation

### Supported File Types

```markdown
# File Type Matrix

## Images
| Type | Extensions | Max Size | Processing |
|------|------------|----------|------------|
| Profile photos | jpg, png, webp | 5MB | Resize, crop, optimize |
| Product images | jpg, png, webp | 10MB | Thumbnails, watermark |
| Documents | pdf, doc, docx | 25MB | Preview generation |
| Attachments | * | 50MB | Malware scan |

## Video
| Type | Extensions | Max Size | Processing |
|------|------------|----------|------------|
| User videos | mp4, webm, mov | 500MB | Transcode, thumbnails |
| Live streams | - | - | HLS/DASH segmentation |

## Audio
| Type | Extensions | Max Size | Processing |
|------|------------|----------|------------|
| Voice messages | mp3, m4a, ogg | 25MB | Transcode, waveform |
| Podcasts | mp3, m4a | 200MB | Normalize, transcode |

## Validation Rules

| Check | Action on Failure |
|-------|-------------------|
| File extension | Reject immediately |
| MIME type verification | Reject (prevent extension spoofing) |
| File size | Reject with clear message |
| Malware scan | Quarantine, alert security |
| Content analysis | Flag for review (if inappropriate) |
```

### Validation Implementation

```typescript
interface FileValidation {
  allowed_extensions: string[];
  allowed_mime_types: string[];
  max_size_bytes: number;
  require_malware_scan: boolean;
  require_content_analysis: boolean;
}

const validations: Record<string, FileValidation> = {
  profile_photo: {
    allowed_extensions: ['jpg', 'jpeg', 'png', 'webp'],
    allowed_mime_types: ['image/jpeg', 'image/png', 'image/webp'],
    max_size_bytes: 5 * 1024 * 1024,  // 5MB
    require_malware_scan: true,
    require_content_analysis: true
  },
  document: {
    allowed_extensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
    allowed_mime_types: [
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    ],
    max_size_bytes: 25 * 1024 * 1024,  // 25MB
    require_malware_scan: true,
    require_content_analysis: false
  }
};
```

---

## Upload Architecture

### Upload Flow

```markdown
## Upload Pipeline

```
Client                    API                      Storage
  │                        │                          │
  ├─── Request Upload ────▶│                          │
  │                        │                          │
  │◀── Presigned URL ──────┤                          │
  │    (Direct to storage) │                          │
  │                        │                          │
  ├────────────────────────┼─── Upload File ─────────▶│
  │                        │                          │
  │◀───────────────────────┼─── Upload Complete ──────┤
  │                        │                          │
  ├─── Confirm Upload ────▶│                          │
  │                        ├─── Trigger Processing ──▶│
  │                        │                          │
  │◀── File Metadata ──────┤                          │
```

### Direct Upload (Recommended for Large Files)

```typescript
// 1. Client requests upload URL
// POST /api/uploads/initiate
interface InitiateUploadRequest {
  filename: string;
  content_type: string;
  size_bytes: number;
  purpose: 'profile_photo' | 'document' | 'attachment';
}

interface InitiateUploadResponse {
  upload_id: string;
  upload_url: string;        // Presigned S3 URL
  expires_at: string;
  fields?: Record<string, string>;  // For form-based upload
}

// 2. Client uploads directly to storage
// PUT {upload_url} with file content

// 3. Client confirms upload
// POST /api/uploads/{upload_id}/complete
interface CompleteUploadResponse {
  file_id: string;
  url: string;
  thumbnails?: Record<string, string>;
  status: 'processing' | 'ready';
}
```

### Resumable Uploads (Large Files)

```markdown
## Chunked Upload Protocol

1. **Initiate**: Create upload session, get upload_id
2. **Upload Chunks**: Upload file in 5MB chunks
3. **Complete**: Signal all chunks uploaded
4. **Assemble**: Server assembles chunks

### Chunk Upload API

```
POST /uploads/initiate
  → { upload_id, chunk_size }

PUT /uploads/{upload_id}/chunks/{chunk_number}
  Body: chunk data
  → { chunk_id, bytes_received }

POST /uploads/{upload_id}/complete
  Body: { total_chunks, checksum }
  → { file_id, status }

GET /uploads/{upload_id}/status
  → { chunks_received: [1,2,3], missing: [4], progress: 75% }
```
```

---

## Storage Strategy

### Storage Tiers

```markdown
## Storage Architecture

### Tier Design

| Tier | Storage | Use Case | Cost |
|------|---------|----------|------|
| Hot | S3 Standard | Recent uploads, active files | $$$ |
| Warm | S3 IA | 30-90 day old files | $$ |
| Cold | S3 Glacier | Archives, compliance | $ |

### Lifecycle Rules

```yaml
# S3 Lifecycle Policy
rules:
  - id: user-uploads
    status: Enabled
    transitions:
      - days: 30
        storage_class: STANDARD_IA
      - days: 90
        storage_class: GLACIER
    expiration:
      days: 365  # Or never for compliance

  - id: temporary-uploads
    prefix: temp/
    status: Enabled
    expiration:
      days: 1
```

### Storage Organization

```
bucket/
├── uploads/
│   └── {year}/{month}/{day}/
│       └── {upload_id}/
│           ├── original.{ext}
│           ├── processed/
│           │   ├── thumbnail_sm.webp
│           │   ├── thumbnail_md.webp
│           │   └── optimized.webp
│           └── metadata.json
├── temp/
│   └── {upload_id}/
│       └── chunks/
└── archives/
    └── {year}/
```
```

### Storage Schema

```typescript
interface StoredFile {
  id: string;
  user_id: string;

  // Original file
  original: {
    key: string;          // S3 key
    filename: string;     // Original filename
    content_type: string;
    size_bytes: number;
    checksum: string;     // SHA-256
  };

  // Processed versions
  variants: {
    [name: string]: {
      key: string;
      content_type: string;
      size_bytes: number;
      dimensions?: { width: number; height: number };
    };
  };

  // Metadata
  purpose: string;
  status: 'uploading' | 'processing' | 'ready' | 'failed';
  visibility: 'public' | 'private' | 'signed';
  metadata?: Record<string, any>;

  // Timestamps
  created_at: Date;
  processed_at?: Date;
  expires_at?: Date;
}
```

---

## Media Processing

### Image Processing Pipeline

```markdown
## Image Processing

### Pipeline Steps

1. **Validate**: Check format, dimensions, malware
2. **Sanitize**: Strip EXIF metadata (privacy)
3. **Process**: Resize, crop, optimize
4. **Generate Variants**: Thumbnails, responsive sizes
5. **Store**: Save all versions

### Variant Definitions

| Variant | Dimensions | Format | Quality | Use |
|---------|------------|--------|---------|-----|
| thumbnail_sm | 100x100 | webp | 80 | Lists, avatars |
| thumbnail_md | 300x300 | webp | 80 | Cards, previews |
| standard | 800x800 | webp | 85 | Detail views |
| original | preserved | original | 100 | Download |

### Processing Configuration

```typescript
interface ImageProcessingConfig {
  variants: {
    name: string;
    width: number;
    height: number;
    fit: 'cover' | 'contain' | 'fill';
    format: 'webp' | 'jpeg' | 'png';
    quality: number;
  }[];
  strip_metadata: boolean;
  auto_orient: boolean;
  watermark?: {
    image: string;
    position: 'center' | 'bottom-right';
    opacity: number;
  };
}
```
```

### Video Processing Pipeline

```markdown
## Video Processing

### Pipeline Steps

1. **Validate**: Check format, duration, size
2. **Scan**: Malware, content moderation
3. **Transcode**: Convert to streaming formats
4. **Generate**: Thumbnails, preview GIF
5. **Segment**: HLS/DASH for streaming

### Output Formats

| Quality | Resolution | Bitrate | Use |
|---------|------------|---------|-----|
| 360p | 640x360 | 800 kbps | Mobile, slow connections |
| 720p | 1280x720 | 2.5 Mbps | Standard |
| 1080p | 1920x1080 | 5 Mbps | High quality |

### Streaming Output

```
video/
├── manifest.m3u8        # HLS master playlist
├── 360p/
│   ├── playlist.m3u8
│   └── segment_*.ts
├── 720p/
│   └── ...
├── 1080p/
│   └── ...
├── thumbnail.jpg
└── preview.gif
```
```

### Document Processing

```markdown
## Document Processing

### PDF Processing
- Extract text (for search indexing)
- Generate page thumbnails
- Create preview images

### Office Documents
- Convert to PDF for preview
- Extract text content
- Generate thumbnail of first page
```

---

## CDN Strategy

### CDN Architecture

```markdown
## Content Delivery

```
User Request
     │
     ▼
┌─────────────┐
│    CDN      │ ─── Cache Hit ──▶ Serve
│  (CloudFront│
│   /Fastly)  │
└─────┬───────┘
      │ Cache Miss
      ▼
┌─────────────┐
│   Origin    │
│  (S3/API)   │
└─────────────┘
```

### CDN Configuration

| Content Type | Cache TTL | Invalidation |
|--------------|-----------|--------------|
| Static assets | 1 year | Version in URL |
| User uploads | 1 week | On update |
| Dynamic content | 0 (no cache) | N/A |

### URL Strategy

```typescript
// Public files (via CDN)
// https://cdn.example.com/files/{file_id}/{variant}.{ext}

// Private files (signed URLs)
// https://cdn.example.com/files/{file_id}/{variant}.{ext}?token={jwt}&expires={timestamp}

interface SignedUrlConfig {
  file_id: string;
  variant: string;
  expires_in_seconds: number;
  user_id?: string;  // For audit
}

function generateSignedUrl(config: SignedUrlConfig): string {
  const expires = Date.now() + config.expires_in_seconds * 1000;
  const token = jwt.sign({
    file_id: config.file_id,
    variant: config.variant,
    user_id: config.user_id,
    exp: expires
  }, SECRET_KEY);

  return `${CDN_BASE}/${config.file_id}/${config.variant}?token=${token}`;
}
```
```

---

## Security

### Security Measures

```markdown
## File Security

### Upload Security
- [ ] Validate file type by magic bytes (not just extension)
- [ ] Scan all uploads for malware
- [ ] Limit upload size per request
- [ ] Rate limit uploads per user
- [ ] Use presigned URLs (don't proxy through app)

### Storage Security
- [ ] Encrypt at rest (S3 SSE or KMS)
- [ ] Private bucket (no public access)
- [ ] Signed URLs for access
- [ ] Audit all access

### Serving Security
- [ ] Content-Disposition headers (prevent XSS)
- [ ] Content-Type validation
- [ ] No executable content types
- [ ] CORS configuration

### Content Moderation
- [ ] Automated image moderation (AWS Rekognition, Google Vision)
- [ ] Flag suspicious content for review
- [ ] User reporting mechanism
- [ ] Removal workflow
```

### Access Control

```typescript
enum FileVisibility {
  PUBLIC = 'public',       // Anyone can access via CDN
  PRIVATE = 'private',     // Owner only, signed URL
  SHARED = 'shared',       // Specific users, signed URL
  INTERNAL = 'internal'    // System use only
}

interface FileAccessPolicy {
  file_id: string;
  visibility: FileVisibility;
  owner_id: string;
  shared_with?: string[];  // User IDs
  expires_at?: Date;
}

// Access check
async function canAccessFile(
  user_id: string,
  file_id: string
): Promise<boolean> {
  const policy = await getFilePolicy(file_id);

  if (policy.visibility === 'public') return true;
  if (policy.owner_id === user_id) return true;
  if (policy.shared_with?.includes(user_id)) return true;

  return false;
}
```

---

## Monitoring & Metrics

```markdown
## File System Metrics

### Upload Metrics
| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| Upload success rate | Successful / Total | < 99% |
| Upload latency | Time to complete | > 30s (P95) |
| Processing time | Upload to ready | > 5 min |
| Queue depth | Pending processing | > 1000 |

### Storage Metrics
| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| Storage used | Total bytes | > 80% quota |
| Egress bandwidth | CDN transfer | Unusual spike |
| Error rate | Failed requests | > 1% |

### CDN Metrics
| Metric | Description | Target |
|--------|-------------|--------|
| Cache hit ratio | Hits / Total | > 90% |
| Origin latency | Cache miss response | < 200ms |
| Error rate | 4xx/5xx responses | < 0.1% |
```

---

## Upstream Feedback: When to Trigger

| Issue Found | Feedback To | Example |
|-------------|-------------|---------|
| File types not defined | BA | "What document types should we support?" |
| Security requirements unclear | Security | "Need malware scanning policy" |
| Processing too complex | Architect | "Video transcoding needs dedicated service" |
| UX issues with upload | UX | "Need progress feedback for large files" |

---

## Outputs

This skill produces:

1. **File Type Matrix** (`docs/files/supported-types.md`)
2. **Upload Architecture** (`docs/files/upload-flow.md`)
3. **Processing Pipeline** (`docs/files/processing.md`)
4. **CDN Strategy** (`docs/files/cdn-strategy.md`)
5. **Security Policy** (`docs/files/security.md`)
