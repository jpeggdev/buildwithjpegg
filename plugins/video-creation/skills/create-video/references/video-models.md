# Video Generation Models -- Detailed Reference

## Seedance 2.0 (Primary for Image-to-Video)

- **Model ID**: `st-ai/super-seed2`
- **Task type**: i2v (image-to-video), t2v (text-to-video)
- **Capabilities**: Multimodal input (up to 9 images, 3 videos, 3 audio), 2K output, lip-sync in 8+ languages

### Parameters

| Param | Type | Required | Default | Description |
|-|-|-|-|-|
| `model` | string | No | `seedance_2.0_fast` | `seedance_2.0_fast` or `seedance_2.0` |
| `prompt` | string | Yes | -- | Supports `@image_file_N`, `@video_file_N`, `@audio_file_N` refs |
| `functionMode` | string | No | `omni_reference` | `omni_reference` or `first_last_frames` |
| `ratio` | string | No | `16:9` | `21:9`, `16:9`, `4:3`, `1:1`, `3:4`, `9:16` |
| `duration` | integer | No | 5 | 4-15 seconds |
| `filePaths` | array | No | -- | Image URLs (alternative to image_files) |
| `image_files` | array | No | -- | Up to 9 image URLs |
| `video_files` | array | No | -- | Up to 3 video URLs, total max 15s |
| `audio_files` | array | No | -- | Up to 3 audio URLs |

### Pricing

- **Base**: 40 credits per task
- **Fast mode**: 10 credits/sec (no video ref), 20 credits/sec (with video ref)
- **Standard mode**: 20 credits/sec (no video ref), 40 credits/sec (with video ref)

### Function Modes

**omni_reference** (default): Images serve as visual references. The model uses them to guide style, composition, and content. Best for maintaining visual consistency from keyframes.

**first_last_frames**: First and last images define the start and end frames of the video. The model interpolates between them. Use when precise start/end states matter.

### Generation Time

Approximately 60 seconds for a 5-second clip.

---

## Sora 2

- **Model ID**: `fal-ai/sora-2/text-to-video`
- **Task type**: t2v (text-to-video)
- **Output**: 720p video with optional audio

### Parameters

| Param | Type | Required | Default | Description |
|-|-|-|-|-|
| `prompt` | string | Yes | -- | Video generation prompt |
| `duration` | integer | No | 4 | 4, 8, or 12 seconds |
| `aspect_ratio` | string | No | `16:9` | Video aspect ratio |
| `resolution` | string | No | `720p` | Output resolution |
| `model` | string | No | `sora-2` | Model version |

### Pricing

- 40 credits per second of output
- 4s = 160 credits, 8s = 320 credits, 12s = 480 credits

### Notes

- Text-to-video only (no image input)
- Strong prompt comprehension
- Good for standalone clips without keyframes

---

## WAN 2.6

- **Model IDs**: Varies by task type (t2v, i2v, reference-to-video)
- **Task types**: t2v, i2v, reference

### Variants

Check available models: `https://api.xskill.ai/api/v3/models`

Filter for models containing "wan" in the ID.

### Notes

- Good subject consistency in reference mode
- Multiple format/resolution options

---

## Hailuo 2.3

- **Model IDs**: Varies (fast/standard, pro/standard)
- **Task types**: i2v, t2v

### Variants

- Fast variants: Quicker generation, lower cost
- Standard variants: Higher quality, longer generation time
- Pro variants: Best quality

---

## VIDU Q3

- **Model ID**: Check model list
- **Task type**: i2v (image-to-video)

Image-to-video specialist. Good for single-image animation.

---

## Other Video Models

### Jimeng Video 3.5 Pro
- Multiple duration variants (standard, 10s, 12s)
- ByteDance's video generation

### OmniHuman v1.5
- Human-focused video generation
- Good for character animation

### Dreamactor v2
- Character animation and motion transfer
- Drive motion from reference videos

---

## Choosing a Model

| Scenario | Recommended Model |
|-|-|
| Keyframe images available | Seedance 2.0 (omni_reference mode) |
| Start and end frames defined | Seedance 2.0 (first_last_frames mode) |
| Text prompt only, no images | Sora 2 |
| Need lip sync | Seedance 2.0 (with audio_files) |
| Single image animation | VIDU Q3 or Hailuo 2.3 |
| Subject consistency needed | WAN 2.6 reference mode |
| Budget-conscious | Seedance 2.0 Fast |
| Maximum quality | Seedance 2.0 Standard or Sora 2 |

## Fetching Latest Model Docs

```
GET https://api.xskill.ai/api/v3/models/<url-encoded-model-id>/llms.txt
```

Full model catalog: `https://api.xskill.ai/api/v3/models`
