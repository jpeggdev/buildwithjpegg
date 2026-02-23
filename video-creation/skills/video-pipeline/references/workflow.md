# Video Pipeline -- Detailed Workflow Reference

## Complete Walkthrough

### Pre-flight Checks

Before starting any step, verify:

1. `XSKILL_API_KEY` environment variable is set
2. Project directory exists or can be created
3. Required scripts are accessible via the skill path

### Step 1: Storyboard -- Detailed

**Input**: User's concept, idea, or script
**Output**: `<project>/storyboard.md`

Follow the `create-storyboard` skill process:
1. Capture concept
2. Explore five dimensions (only dimensions relevant to the project)
3. Build timeline with shots
4. Each shot must have an Image Prompt field
5. Save the storyboard to the project folder

**Validation**: Every shot must have a time range, camera, scene, action, and image prompt.

### Step 2: Images -- Detailed

**Input**: Storyboard with image prompts
**Output**: Downloaded images in `<project>/images/`, manifest entries

For each shot in the storyboard:

```bash
# Generate
RESULT=$(bash "<create-image-skill-path>/scripts/generate-image.sh" \
  "the image prompt from the shot" \
  "fal-ai/flux-2/flash" \
  "landscape_16_9" \
  1)

# Extract URL from result
IMAGE_URL=$(python3 -c "import json,sys; print(json.loads(sys.argv[1])['output']['images'][0])" "$RESULT")

# Download
bash "<video-pipeline-skill-path>/scripts/download-assets.sh" "$IMAGE_URL" "<project>/images/shot-01.png"
```

**Image size mapping from storyboard aspect ratio:**

| Storyboard Ratio | Image Size Preset |
|-|-|
| 16:9 | `landscape_16_9` |
| 4:3 | `landscape_4_3` |
| 1:1 | `square` |
| 3:4 | `portrait_3_4` |
| 9:16 | `portrait_9_16` |

### Step 3: Video -- Detailed

**Input**: Image URLs, video prompt, model choice
**Output**: Downloaded video in `<project>/video/`, manifest entry

Build the video prompt by combining storyboard context:
- Overall project style/mood
- Scene-by-scene descriptions
- Reference images using `@image_file_N` syntax

```bash
RESULT=$(bash "<create-video-skill-path>/scripts/generate-video.sh" \
  "st-ai/super-seed2" \
  "the combined prompt with @image_file_1 references" \
  "16:9" \
  5 \
  "https://keyframe1.jpg" "https://keyframe2.jpg" "https://keyframe3.jpg")

VIDEO_URL=$(python3 -c "import json,sys; print(json.loads(sys.argv[1])['output']['images'][0])" "$RESULT")

bash "<video-pipeline-skill-path>/scripts/download-assets.sh" "$VIDEO_URL" "<project>/video/output.mp4"
```

### Step 4: Gallery -- Detailed

**Input**: All downloaded assets
**Output**: `<project>/gallery.html`

1. Read the gallery template from `assets/gallery-template.html`
2. Build the asset list from the manifest or by scanning the project directory
3. Replace template placeholders:
   - `{{PROJECT_TITLE}}` -> project name
   - `{{IMAGES_JSON}}` -> JSON array of image objects
   - `{{VIDEO_SRC}}` -> path to video file
4. Write to `<project>/gallery.html`

## Multi-Clip Videos

For storyboards with more than 15 seconds of content (Seedance max), split into multiple video clips:

1. Group shots into clips of 4-15 seconds each
2. Generate one video per clip
3. Each clip gets its own set of reference images
4. Download all clips to `<project>/video/clip-01.mp4`, `clip-02.mp4`, etc.
5. The gallery shows all clips in sequence

## Resuming a Pipeline

If a project folder already exists with a `manifest.json`:

1. Read the manifest to understand current state
2. Check which assets have been generated and downloaded
3. Offer to continue from where it left off
4. Skip steps that are already complete

## Cost Estimation Table

| Component | Model | Per-Unit Cost | Example (3-shot, 5s video) |
|-|-|-|-|
| Images | Flux 2 Flash | 2 credits/image | 6 credits |
| Video | Seedance 2.0 Fast | ~20 credits/sec | ~100 credits |
| **Total** | | | **~106 credits** |

| Component | Model | Per-Unit Cost | Example (3-shot, 5s video) |
|-|-|-|-|
| Images | Seedream 4.5 | varies | ~15 credits |
| Video | Sora 2 | 40 credits/sec | ~200 credits |
| **Total** | | | **~215 credits** |
