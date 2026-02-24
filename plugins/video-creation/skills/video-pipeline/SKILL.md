---
name: video-pipeline
description: This skill should be used when the user asks to "run the full video pipeline", "generate a video project", "create a video from start to finish", "run the video workflow", "start a video project", or wants to orchestrate the complete storyboard-to-video-to-gallery workflow. Coordinates all steps -- storyboard creation, image generation, video generation, asset download, and HTML gallery creation.
---

# Video Pipeline

Orchestrate the complete video generation workflow from concept to finished project with downloadable assets and an HTML gallery. The user can enter at any step.

## Pipeline Steps

```
1. Storyboard  -->  2. Images  -->  3. Video  -->  4. Download & Gallery
   (concept to        (keyframe       (images to      (save assets,
    shot plan)         generation)      video)          build HTML)
```

## Entry Point Detection

Ask the user where to start:

1. **From scratch**: Start at step 1 (storyboard). No prior assets needed.
2. **Have a storyboard**: Start at step 2 (images). Need a storyboard file path.
3. **Have images**: Start at step 3 (video). Need image URLs.
4. **Have video**: Start at step 4 (download/gallery). Need video URL(s).

## Project Folder Structure

Create a project folder to organize all assets:

```
<project-name>/
  storyboard.md          -- The storyboard document
  images/                -- Generated keyframe images
    shot-01.png
    shot-02.png
    ...
  video/                 -- Generated video files
    output.mp4
  gallery.html           -- HTML gallery with carousel
  manifest.json          -- Project manifest tracking all URLs and paths
```

Create this folder at the start of the pipeline. The project name comes from the user's concept or storyboard title.

## Step 1: Storyboard

Invoke the `create-storyboard` skill workflow:

1. Gather the concept from the user
2. Walk through the five dimensions (narrative, visual, camera, motion, sound)
3. Build the timed shot list with image prompts
4. Save as `<project>/storyboard.md`

## Step 2: Image Generation

Invoke the `create-image` skill workflow:

1. Read the storyboard to extract image prompts
2. Confirm model choice with user (default: Flux 2 Flash at 2 credits/image)
3. Report total estimated cost before generating
4. Generate one image per shot by running the `generate-image.sh` script from the `create-image` skill
5. Download each image to `<project>/images/shot-NN.png` using `scripts/download-assets.sh` (args: `<url> <output_path>`)
6. Update `manifest.json` with both URLs and local paths

Process images sequentially. After each generation, show the user the result URL so they can preview. If a result is unsatisfactory, offer to regenerate with a modified prompt.

## Step 3: Video Generation

Invoke the `create-video` skill workflow:

1. Collect all image URLs from the manifest (or from user input if entering at step 3)
2. Confirm video model with user (default: Seedance 2.0 Fast)
3. Build the video prompt, referencing images with `@image_file_N` syntax
4. Report estimated cost before generating
5. Generate video by running the `generate-video.sh` script from the `create-video` skill
6. Download video to `<project>/video/output.mp4`
7. Update `manifest.json`

## Step 4: Download and Gallery

1. Verify all assets are downloaded to the project folder
2. For any remote URLs not yet downloaded, use `scripts/download-assets.sh`
3. Generate `gallery.html` using the template at `assets/gallery-template.html`
4. Customize the template with the actual project name and asset file paths

### Gallery Generation

Read the template from `assets/gallery-template.html`. Replace the placeholder data with actual project assets:

- Set the project title
- Populate the image carousel with local image paths (`images/shot-01.png`, etc.)
- Add the video player with the local video path (`video/output.mp4`)
- Write to `<project>/gallery.html`

## Manifest Format

Track all assets in `manifest.json`:

```json
{
  "project": "project-name",
  "created": "2025-01-15T10:30:00Z",
  "storyboard": "storyboard.md",
  "images": [
    {
      "shot": 1,
      "prompt": "the image prompt used",
      "url": "https://remote-url.jpg",
      "local": "images/shot-01.png",
      "model": "fal-ai/flux-2/flash",
      "credits": 2
    }
  ],
  "videos": [
    {
      "prompt": "the video prompt used",
      "url": "https://remote-url.mp4",
      "local": "video/output.mp4",
      "model": "st-ai/super-seed2",
      "credits": 100,
      "duration": 5
    }
  ],
  "total_credits": 106
}
```

## Cost Summary

At the end of the pipeline, display a cost summary:

- Number of images generated and total image credits
- Video duration and video credits
- Total credits spent

## Error Recovery

If any step fails:
- Report the error clearly
- The manifest tracks what has been completed
- The user can re-enter the pipeline at the failed step
- Previously generated assets are preserved in the project folder
