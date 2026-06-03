# Research Question

## 当前 Idea 的研究空隙

基于当前 idea card、关键词扩展、5 篇论文摘要和 literature matrix，当前可见研究空隙是：

1. **扩散生成对抗样本与 VLM 安全评估之间存在断层。**  
   SD-NAE 和 Content-based Unrestricted Adversarial Attack 已经说明 Stable Diffusion 可以用于生成自然/内容级对抗图像，但当前证据主要面向图像分类或普通视觉模型，尚未直接覆盖 VLM/LVLM 的 VQA、captioning、grounding 或安全拒答任务。

2. **VLM/LVLM 攻击研究多数不是自然扩散编辑。**  
   Visual Adversarial Examples Jailbreak 和 FigStep 直接面向 VLM/LVLM 安全，但前者更接近视觉对抗扰动/jailbreak，后者是 typographic visual prompt。它们与“自然场景中的语义保持扩散编辑”不同。

3. **现有 red teaming benchmark 可提供评估框架，但不解决攻击图像生成。**  
   RTVLM 提供 faithfulness、privacy、safety、fairness 等评估维度，但其重点是 benchmark 和 alignment，不是生成自然对抗图像。

4. **课程项目可行的切入点不是复现完整 jailbreak，而是做轻量级、低风险的 VLM correctness robustness demo。**  
   更适合优先选择 benign 任务，例如 captioning、VQA、object/attribute grounding，避免直接处理高风险 harmful-content jailbreak。

5. **关键未解决问题是如何同时衡量 attack success 与 semantic/natural preservation。**  
   可用指标包括 VQA accuracy、caption correctness、hallucination rate、CLIP similarity、LPIPS、SSIM/PSNR、人工自然性评分等，但具体组合需要根据实验规模简化。

## Candidate Research Questions

### RQ1: Diffusion-based natural image editing for benign VLM correctness failures

**Research question:**  
Can diffusion-based natural image editing generate visually plausible and approximately semantic-preserving image variants that cause VLMs to make more errors on benign captioning or VQA tasks under normal text prompts?

**研究对象：**  
开源 VLM/LVLM，例如 LLaVA、BLIP-2、InstructBLIP 或 Qwen-VL；具体模型需根据本地算力和可用 API 决定。

**输入数据：**  
小规模 COCO、VQAv2、GQA 或自选自然图像；每张图像配一个普通 captioning prompt 或 VQA question。

**实验任务：**

- 原图 vs. diffusion-edited 图像的 VLM 输出比较；
- captioning correctness 或 VQA accuracy 变化；
- semantic/natural preservation 评估，例如 CLIP similarity、LPIPS/SSIM，或人工 1–5 分自然性评分；
- 可选：记录 hallucination 或 object/attribute error。

**可行性：**  
高。可以小规模完成，不需要处理危险 jailbreak 内容；即使没有完整攻击优化，也可以用 text-guided image editing / instruction-guided editing 构造轻量样例。

**风险：**

- diffusion edit 可能改变真实语义，导致错误不是“对抗性”而是合理响应；
- 没有梯度优化时攻击成功率可能较低；
- VLM 输出主观性强，需要明确评分规则；
- 是否真正“semantic-preserving”需要人工或指标辅助验证。

### RQ2: Natural diffusion-edited visual inputs versus typographic visual prompts for VLM safety stress testing

**Research question:**  
How do natural diffusion-edited images differ from typographic visual prompts in triggering VLM robustness or safety failures under black-box evaluation?

**研究对象：**  
开源 LVLM 或商业 VLM 的安全合规黑盒接口；更推荐先使用开源 LVLM。

**输入数据：**  
两类图像：

1. diffusion-edited natural images；
2. typographic visual prompt images inspired by FigStep, but restricted to benign or non-harmful tasks.

**实验任务：**

- 比较两类视觉输入在 VQA/captioning/misleading instruction 场景下的失败率；
- 记录 attack success rate、refusal/over-refusal、response correctness；
- 分析自然性、可察觉性和安全边界。

**可行性：**  
中等。对比设计清晰，但 typographic prompt 容易滑向 jailbreak，需要严格使用 benign 内容；如果涉及商业模型，还需成本和合规约束。

**风险：**

- 安全边界敏感，容易偏离课程项目的低风险目标；
- FigStep 类方法已有较强已有工作，创新点可能不足；
- 自然扩散图像与 typographic image 的任务公平性难以控制。

### RQ3: A lightweight evaluation framework for semantic-preserving adversarial image edits in VLM red teaming

**Research question:**  
What minimal evaluation protocol can jointly measure attack success, semantic preservation, and perceptual naturalness for diffusion-edited image-only attacks on VLMs?

**研究对象：**  
评估协议本身，以及一个或两个开源 VLM 作为 demonstration targets。

**输入数据：**  
小规模自然图像集合，配套普通 VQA/caption prompts；可包含 COCO/VQAv2 子集或手工挑选样例。

**实验任务：**

- 设计三类指标：attack success、semantic preservation、naturalness；
- 对原图和 diffusion-edited 图像进行对比；
- 给出 case study，说明哪些编辑导致 VLM 输出变化但人类仍认为图像自然。

**可行性：**  
中高。更偏研究规划和评估框架，适合课程项目写作；对实现强攻击的要求低于 RQ1。

**风险：**

- 如果只做评估框架而缺少实际攻击样例，实验贡献可能偏弱；
- 指标选择可能被质疑主观；
- 需要避免把普通数据增强误称为 adversarial attack。

## Recommended Research Question

**推荐问题：RQ1**

> Can diffusion-based natural image editing generate visually plausible and approximately semantic-preserving image variants that cause VLMs to make more errors on benign captioning or VQA tasks under normal text prompts?

## Why This Question Matters

该问题最适合课程项目，因为它同时满足：

1. **贴合原始 idea。**  
   关注 diffusion-based image editing、image-only attack、semantic/natural preservation 和 VLM robustness。

2. **风险可控。**  
   使用 benign captioning/VQA/grounding failure，不需要直接复现 harmful jailbreak。

3. **实验规模可控。**  
   可以用少量图像、一个开源 VLM、一个扩散编辑工具和简单指标完成最小实验。

4. **与已有工作形成清晰区别。**  
   它不是只做分类器自然对抗样本，也不是 typographic jailbreak，而是把自然扩散编辑用于 VLM 的普通视觉语言任务鲁棒性测试。

## Potential Novelty

推荐问题的潜在新意在于：

- 将 SD-NAE / unrestricted adversarial attack 中的自然扩散生成思路转向 VLM 输出层面的 captioning/VQA failure；
- 避免 FigStep 式 typographic visual prompt，强调自然图像编辑；
- 避免纯文本 jailbreak，保持 normal text prompt；
- 在小规模实验中同时报告 attack success、semantic preservation 和 naturalness，而不是只报告模型错误。

## Novelty Risk

- Candidate 1（Efficient Generation of Targeted and Transferable Adversarial Examples for Vision-Language Models via Diffusion Models）可能已经非常接近本问题，必须优先全文核查。
- SD-NAE 和 Content-based Unrestricted Adversarial Attack 可能已有部分自然/语义级攻击指标，需要核查是否可直接迁移。
- 若只做普通 diffusion edit + VLM 测试，可能被认为是工程 demo，而不是研究问题。

## Experiment Risk

- diffusion edit 改动过大时，VLM 输出变化可能是合理的，不构成 adversarial failure；
- edit 改动过小时，VLM 可能不受影响，attack success 低；
- VLM 输出开放式，captioning correctness 评分较难；
- 本地运行 VLM/扩散模型可能受算力限制；
- 商业 VLM 黑盒测试存在成本、接口、合规限制，建议只作为 optional future work。

## Minimal Experiment Plan

1. **数据选择：**  
   选 20–50 张 COCO/VQAv2/GQA 或自选自然图像，每张图像配 1 个普通 captioning 或 VQA prompt。

2. **图像编辑：**  
   使用 Stable Diffusion / instruction-guided image editing 生成自然变体，优先做轻微属性、背景、局部物体或纹理变化。

3. **VLM 测试：**  
   对原图和编辑图输入相同普通文本 prompt，记录 VLM 输出。

4. **输出评估：**

   - VQA accuracy / response correctness；
   - caption semantic error 或 hallucination；
   - attack success rate：原图正确、编辑图错误的比例；
   - semantic preservation：CLIP similarity 或人工判断；
   - perceptual naturalness：人工评分或简单视觉质量检查。

5. **案例分析：**  
   选 3–5 个成功/失败案例，分析 diffusion edit 为什么影响 VLM。

## Expected Evidence

- 原图与 diffusion-edited 图像对比；
- VLM 输出变化记录；
- attack success rate；
- semantic/natural preservation 指标或人工评分；
- 失败案例分析，说明方法边界。

## Reviewer Concerns

- “语义保持”是否只是主观判断？
- diffusion edit 是否改变了答案本身？
- 样本量是否过小？
- 是否只是数据增强而不是 adversarial attack？
- 与已有 diffusion adversarial VLM 工作是否重复？
- 为什么不直接做 jailbreak？需要说明课程项目选择 benign robustness 的安全理由。

## Difference from Existing Work

与当前已整理的已有工作相比，推荐问题的区别是：

1. **不同于 SD-NAE：**  
   SD-NAE 主要面向图像分类器；本问题面向 VLM 的 captioning/VQA 输出。

2. **不同于 Content-based Unrestricted Adversarial Attack：**  
   该工作关注 unrestricted visual attack 和视觉模型/防御；本问题强调 image-only VLM robustness，并要求 normal text prompt 下的语言输出失败。

3. **不同于 Visual Adversarial Examples Jailbreak：**  
   该工作偏安全 jailbreak 和 aligned LLM 绕过；本问题优先低风险 benign correctness failure，不直接复现 harmful jailbreak。

4. **不同于 FigStep：**  
   FigStep 使用 typographic visual prompts；本问题使用自然场景扩散编辑，避免图像中文字提示成为主要攻击通道。

5. **不同于 Red Teaming Visual Language Models：**  
   RTVLM 是评测数据集/红队 benchmark；本问题关注如何生成并评估 diffusion-edited adversarial image variants。

## Next Papers to Verify Manually

1. Efficient Generation of Targeted and Transferable Adversarial Examples for Vision-Language Models via Diffusion Models
2. SD-NAE: Generating Natural Adversarial Examples with Stable Diffusion
3. Content-based Unrestricted Adversarial Attack
4. Visual Adversarial Examples Jailbreak Aligned Large Language Models
5. FigStep: Jailbreaking Large Vision-Language Models via Typographic Visual Prompts
