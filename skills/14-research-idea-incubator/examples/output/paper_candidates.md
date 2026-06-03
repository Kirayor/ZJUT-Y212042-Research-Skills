# Paper Candidates

Stage: 3 / Paper discovery  
Source priority: OpenAlex API  
Basis: current `research_idea_agent/outputs/keywords.md` search queries around diffusion-based adversarial generation, VLM/LVLM adversarial attacks, image jailbreaks, and visual prompt injection.  
Verification rule: all candidates are metadata-verified through OpenAlex, but paper claims and method details remain `needs manual verification` until full-text reading.

## Candidate 1

- title: Efficient Generation of Targeted and Transferable Adversarial Examples for Vision-Language Models via Diffusion Models
- year: 2024
- source: IEEE Transactions on Information Forensics and Security
- url: https://openalex.org/W4405718359
- doi: https://doi.org/10.1109/tifs.2024.3518072
- pdfUrl: null
- relevance: Core candidate. Directly combines diffusion models, adversarial example generation, transferability, and vision-language models.
- verification: needs manual verification; OpenAlex metadata retrieved from query `diffusion model adversarial examples vision-language model`.

## Candidate 2

- title: SD-NAE: Generating Natural Adversarial Examples with Stable Diffusion
- year: 2023
- source: arXiv (Cornell University)
- url: https://openalex.org/W4388964503
- doi: https://doi.org/10.48550/arxiv.2311.12981
- pdfUrl: https://arxiv.org/pdf/2311.12981
- relevance: Core candidate for natural-looking adversarial examples generated with Stable Diffusion; important for semantic/naturalness framing even if not VLM-specific.
- verification: needs manual verification; OpenAlex metadata retrieved from query `Stable Diffusion adversarial examples`.

## Candidate 3

- title: AdvDiff: Generating Unrestricted Adversarial Examples Using Diffusion Models
- year: 2024
- source: Lecture Notes in Computer Science
- url: https://openalex.org/W4403003132
- doi: https://doi.org/10.1007/978-3-031-72952-2_6
- pdfUrl: null
- relevance: Core/adjacent candidate for unrestricted adversarial examples using diffusion models; useful for comparing unrestricted/natural attacks with semantic-preserving editing.
- verification: needs manual verification; OpenAlex metadata retrieved from query `Stable Diffusion adversarial examples`.

## Candidate 4

- title: Content-based Unrestricted Adversarial Attack
- year: 2023
- source: arXiv (Cornell University)
- url: https://openalex.org/W4377130782
- doi: https://doi.org/10.48550/arxiv.2305.10665
- pdfUrl: https://arxiv.org/pdf/2305.10665
- relevance: Adjacent candidate for unrestricted/content-based adversarial attacks; may inform semantic-preserving or content-level perturbation design.
- verification: needs manual verification; OpenAlex metadata retrieved from query `Stable Diffusion adversarial examples`; full metadata was partially truncated in fetch result, so confirm before citation use.

## Candidate 5

- title: Break the Visual Perception: Adversarial Attacks Targeting Encoded Visual Tokens of Large Vision-Language Models
- year: 2024
- source: Proceedings of the 32nd ACM International Conference on Multimedia
- url: https://openalex.org/W4403791703
- doi: https://doi.org/10.1145/3664647.3680779
- pdfUrl: null
- relevance: Core VLM attack candidate. Focuses on adversarial attacks against encoded visual tokens in large vision-language models; useful for image-side attack surface framing.
- verification: needs manual verification; OpenAlex metadata retrieved from query `large vision-language model adversarial attack`.

## Candidate 6

- title: Visual Adversarial Examples Jailbreak Aligned Large Language Models
- year: 2024
- source: Proceedings of the AAAI Conference on Artificial Intelligence
- url: https://openalex.org/W4393157467
- doi: https://doi.org/10.1609/aaai.v38i19.30150
- pdfUrl: https://ojs.aaai.org/index.php/AAAI/article/download/30150/32038
- relevance: Core VLM/MLLM safety candidate. Directly studies visual adversarial examples as jailbreak inputs for aligned multimodal systems.
- verification: needs manual verification; OpenAlex metadata retrieved from query `large vision-language model adversarial attack`.

## Candidate 7

- title: White-box Multimodal Jailbreaks Against Large Vision-Language Models
- year: 2024
- source: Proceedings of the 32nd ACM International Conference on Multimedia
- url: https://openalex.org/W4403791397
- doi: https://doi.org/10.1145/3664647.3681092
- pdfUrl: null
- relevance: Strong VLM jailbreak candidate. Useful for comparing white-box multimodal jailbreak settings with the intended image-only / natural-edit setting.
- verification: needs manual verification; OpenAlex metadata retrieved from query `image jailbreak large vision-language model`.

## Candidate 8

- title: Images are Achilles’ Heel of Alignment: Exploiting Visual Vulnerabilities for Jailbreaking Multimodal Large Language Models
- year: 2024
- source: Lecture Notes in Computer Science
- url: https://openalex.org/W4404971291
- doi: https://doi.org/10.1007/978-3-031-73464-9_11
- pdfUrl: null
- relevance: Strong image-jailbreak candidate. Relevant to visual vulnerabilities and MLLM alignment failures; may help define safety evaluation tasks.
- verification: needs manual verification; OpenAlex metadata retrieved from query `image jailbreak large vision-language model`.

## Candidate 9

- title: FigStep: Jailbreaking Large Vision-Language Models via Typographic Visual Prompts
- year: 2025
- source: Proceedings of the AAAI Conference on Artificial Intelligence
- url: https://openalex.org/W4409348010
- doi: https://doi.org/10.1609/aaai.v39i22.34568
- pdfUrl: https://ojs.aaai.org/index.php/AAAI/article/download/34568/36723
- relevance: Important visual-jailbreak baseline, but typographic visual prompts differ from natural/semantic-preserving image edits.
- verification: needs manual verification; OpenAlex metadata retrieved from query `image jailbreak large vision-language model`. An earlier arXiv version also appears as OpenAlex W4388585701 / DOI https://doi.org/10.48550/arxiv.2311.05608; deduplicate during later review.

## Candidate 10

- title: Red Teaming Visual Language Models
- year: 2024
- source: Findings of the Association for Computational Linguistics ACL 2024
- url: https://openalex.org/W4402670570
- doi: https://doi.org/10.18653/v1/2024.findings-acl.198
- pdfUrl: https://aclanthology.org/2024.findings-acl.198.pdf
- relevance: Relevant for safety-evaluation and red-teaming methodology; less directly about diffusion-generated adversarial images.
- verification: needs manual verification; OpenAlex metadata retrieved from query `image jailbreak large vision-language model`.

## Candidate 11

- title: Anyattack: Towards Large-scale Self-supervised Adversarial Attacks on Vision-language Models
- year: 2025
- source: 2025 IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR)
- url: https://openalex.org/W4413147762
- doi: https://doi.org/10.1109/cvpr52734.2025.01853
- pdfUrl: null
- relevance: Relevant VLM adversarial attack candidate; may provide scalable baseline or comparison point, but diffusion-editing relation is unclear.
- verification: needs manual verification; OpenAlex metadata retrieved from query `large vision-language model adversarial attack`.

## Candidate 12

- title: Jailbreak Vision Language Models via Bi-Modal Adversarial Prompt
- year: 2025
- source: IEEE Transactions on Information Forensics and Security
- url: https://openalex.org/W4411799673
- doi: https://doi.org/10.1109/tifs.2025.3583249
- pdfUrl: null
- relevance: Relevant to VLM jailbreaks but may not fit the selected image-only attack scope if it depends on coordinated text+image prompts.
- verification: needs manual verification; OpenAlex metadata retrieved from query `image jailbreak large vision-language model`.

## Candidate 13

- title: Attack as Defense: Safeguarding Large Vision-Language Models from Jailbreaking by Adversarial Attacks
- year: 2025
- source: Findings of the Association for Computational Linguistics: EMNLP 2025
- url: https://openalex.org/W4416033915
- doi: https://doi.org/10.18653/v1/2025.findings-emnlp.1095
- pdfUrl: https://aclanthology.org/2025.findings-emnlp.1095.pdf
- relevance: Useful defense/safety context; secondary rather than core for adversarial image generation.
- verification: needs manual verification; OpenAlex metadata retrieved from query `large vision-language model adversarial attack`.

## Candidate 14

- title: Enhancing Adversarial Robustness in AI Systems: A Novel Defense Mechanism Using Stable Diffusion
- year: 2024
- source: 2024 2nd DMIHER International Conference on Artificial Intelligence in Healthcare, Education and Industry (IDICAIEI)
- url: https://openalex.org/W4406612511
- doi: https://doi.org/10.1109/idicaiei61867.2024.10842888
- pdfUrl: null
- relevance: Secondary. Stable-Diffusion-related adversarial robustness/defense work; may help contrast attack generation vs purification/defense.
- verification: needs manual verification; OpenAlex metadata retrieved from query `Stable Diffusion adversarial examples`.

## Candidate 15

- title: Palette: Image-to-Image Diffusion Models
- year: 2022
- source: Special Interest Group on Computer Graphics and Interactive Techniques Conference Proceedings
- url: https://openalex.org/W3212516020
- doi: https://doi.org/10.1145/3528233.3530757
- pdfUrl: https://dl.acm.org/doi/pdf/10.1145/3528233.3530757
- relevance: Background method candidate. Not an adversarial paper, but relevant to image-to-image diffusion/editing mechanisms that may support semantic-preserving transformations.
- verification: needs manual verification; OpenAlex metadata retrieved from query `diffusion model adversarial examples vision-language model`.

## Exclusion notes

The OpenAlex results also contained several broad or off-topic records that should not be treated as core candidates without further justification, including general machine learning surveys, medical image generation/reconstruction, wireless intelligence surveys, generic prompt engineering surveys, image data augmentation surveys, and non-VLM diffusion applications.

## Suggested screening priority

1. Core diffusion/adversarial generation: Candidates 1–4.
2. Core VLM/LVLM visual attack and jailbreak: Candidates 5–8.
3. Evaluation/safety baselines: Candidates 9–13.
4. Background/secondary method or defense context: Candidates 14–15.
