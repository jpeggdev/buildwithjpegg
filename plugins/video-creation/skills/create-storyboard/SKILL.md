---
name: create-storyboard
description: This skill should be used when the user asks to "create a storyboard", "plan a video", "break down a video concept", "write a shot list", "plan my scenes", or wants help structuring a video idea into timed shots before generating images or video. Guides users through creating structured English-language storyboards for AI video generation.
---

# Create Storyboard

Create structured, timed storyboards that serve as blueprints for AI video generation. Storyboards produced by this skill feed directly into the `create-image` skill (for keyframe generation) and `create-video` skill (for video synthesis).

## Storyboard Creation Process

### Step 1: Capture the Concept

Gather the core information from the user:

- **Subject**: What is the video about?
- **Duration**: Target length in seconds (4-15s per clip, or multi-clip)
- **Aspect ratio**: 16:9, 9:16, 1:1, 4:3, etc.
- **Style/mood**: Visual aesthetic, color palette, atmosphere
- **Reference material**: Any images, videos, or descriptions to draw from

If the user provides a vague idea, ask focused questions to clarify. Do not proceed with an underspecified concept.

### Step 2: Explore the Five Dimensions

For each dimension, discuss options with the user and make decisions:

1. **Content narrative** -- Story arc, characters, dialogue, key moments
2. **Visual style** -- Aesthetics, lighting, color grading, art direction
3. **Camera language** -- Shot types, camera movement, transitions
4. **Motion and rhythm** -- Action pacing, movement speed, beat sync
5. **Sound design** -- Music style, sound effects, voiceover, silence

Not every dimension applies to every project. Skip what is irrelevant (e.g., a product shot may not need narrative arc).

### Step 3: Build the Timeline

Decompose the concept into timed shots. For each shot, specify:

- **Time range**: Start and end in seconds (e.g., 0:00-0:03)
- **Camera**: Shot type and movement (e.g., "Close-up, slow dolly in")
- **Scene**: What is visible in the frame
- **Action**: What happens during this shot
- **Sound**: Audio for this segment
- **Image prompt**: A detailed prompt for keyframe image generation

The image prompt is critical -- it must be specific enough for an image generation model to produce a usable keyframe. Include style, composition, lighting, and subject details.

### Step 4: Review and Refine

Present the complete storyboard to the user. Check for:

- Logical flow between shots
- Consistent visual style across shots
- Realistic timing (not too much crammed into short durations)
- Image prompts that are detailed and self-contained

### Step 5: Save the Storyboard

Write the storyboard as a markdown file in the project directory using the format specified in `references/storyboard-format.md`. The filename should follow the pattern: `storyboard-<project-name>.md`.

## Output Format

The storyboard is a markdown document with:
- Project metadata header (title, duration, ratio, style)
- Numbered shots with time ranges
- Camera, scene, action, sound, and image prompt for each shot

See `references/storyboard-format.md` for the complete format specification.

## Camera and Shot Reference

For camera terminology and common shot patterns, consult `references/shot-types.md`. Use these terms consistently in shot descriptions and image prompts.

## Working Example

See `examples/example-storyboard.md` for a complete storyboard demonstrating the format and level of detail expected.

## Tips

- Keep individual shots between 2-5 seconds for most video models
- Image prompts should be self-contained -- do not assume context from other shots
- For character consistency across shots, repeat key character descriptions in each image prompt
- Aspect ratio in the storyboard should match the intended video output ratio
- When the user is ready to generate images from the storyboard, direct them to the `create-image` skill
