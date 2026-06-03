# Idea Card

## Raw Idea

Use diffusion models for adversarial example generation in visual-language model (VLM) security. The user is interested in using diffusion-model image editing capabilities to generate more natural and stealthy attack images for VLMs, including possible black-box evaluation of commercial models such as GPT/Gemini in a safe and compliant way.

## Refined Problem

Can diffusion-based image editing generate visually natural, semantically plausible, and stealthy adversarial images that cause VLMs to produce incorrect, unsafe, or misleading outputs, without relying on obvious pixel-level noise?

Current scope preference:

- Target model family: VLMs in general, not fixed to one model yet.
- Commercial VLMs such as GPT-4V/GPT-4o and Gemini may be considered only as optional black-box evaluation targets under safety-compliant testing.
- Core adversarial form: image-only attack with semantic-preserving or natural-looking diffusion edits.
- Text prompts: normal prompts/questions, not the main attack channel.
- Experimental ambition: lightweight reproduction / small-scale demonstration first, not immediate full-scale benchmark reproduction.

## Target Task

Generate or edit images with diffusion models so that, under ordinary visual-language prompts, a VLM fails on one or more downstream behaviors:

1. image description accuracy,
2. VQA correctness,
3. object/attribute grounding,
4. safety refusal or harmful-content handling,
5. multimodal jailbreak-like robustness.

The current preferred formulation is **A + C**:

- **A. Image-only attack**: edit the image while keeping the textual query normal.
- **C. Semantic-preserving / natural edit**: the image remains visually natural and close to the original scene or intended semantics.

## Motivation

Most classic adversarial examples rely on small pixel-level perturbations that may be visually unnatural, fragile, or less meaningful for modern generative/VLM settings. Diffusion models offer a different attack surface: they can edit images at a semantic or natural-image level. This may produce adversarial examples that are more realistic, stealthier to humans, and more relevant to real-world VLM safety testing.

## Core Assumption

Diffusion-based image editing can introduce subtle but semantically meaningful visual changes that preserve human-perceived naturalness while shifting VLM outputs. These edits may expose failure modes that are not well captured by traditional gradient-based or noise-based adversarial attacks.

## Possible Contribution

A feasible course-project contribution could be:

1. A taxonomy of diffusion-based adversarial image generation for VLM safety.
2. A lightweight pipeline for semantic-preserving adversarial image editing.
3. A small evaluation comparing original images vs. diffusion-edited images on VLM responses.
4. Metrics combining attack success, semantic preservation, and perceptual naturalness.
5. A discussion of black-box safety testing implications for open-source and commercial VLMs.

## Required Evidence

Need literature evidence for:

1. adversarial attacks on VLMs / vision-language models,
2. multimodal jailbreak or image-based attacks against VLMs,
3. diffusion models for adversarial example generation,
4. diffusion-based image editing and semantic-preserving perturbation,
5. evaluation metrics for naturalness, semantic similarity, and attack success.

## Unknowns

- Whether prior work has already directly combined diffusion editing with VLM adversarial attacks.
- Which VLM tasks are most feasible for lightweight evaluation.
- Whether image-only diffusion edits are strong enough without adversarial text prompts.
- What datasets/images should be used for a small demo.
- Whether commercial model testing is allowed, affordable, and methodologically meaningful.
- How to define “semantic-preserving” rigorously enough for evaluation.

## Next Questions

1. Should the first literature search focus more on **diffusion-based adversarial image generation** or **VLM/multimodal jailbreak attacks**?
2. Should the lightweight demo prioritize harmless correctness failures, such as VQA/captioning errors, before safety/jailbreak behavior?
3. Should the project frame commercial VLMs only as future work, keeping the main experiment on open-source models?
4. What level of safety-sensitive content is acceptable for this course project? A conservative option is to avoid harmful-content generation and focus on benign robustness failures.
