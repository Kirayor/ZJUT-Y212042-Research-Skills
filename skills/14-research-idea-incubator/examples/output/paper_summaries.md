# Paper Summaries

## Paper: SD-NAE: Generating Natural Adversarial Examples with Stable Diffusion

- 研究问题：如何主动合成自然对抗样本（Natural Adversarial Examples, NAEs），使图像在人类看来接近真实类别、自然可信，但能够误导分类模型，而不是仅被动从真实图像中收集 NAEs。
- 方法：提出 SD-NAE，使用 Stable Diffusion 进行受控生成；通过优化与指定类别对应的 token embedding，并用目标分类器的损失梯度引导生成过程，使生成图像既接近 ground-truth 类别，又能欺骗分类器。
- 实验对象/模型：以图像分类器作为攻击目标；生成器为 Stable Diffusion。论文页面说明其通过精心设计实验验证生成 NAEs 的有效性。
- 主要贡献：将 Stable Diffusion 用于主动生成自然对抗样本；把对抗目标注入扩散生成过程；为“自然、语义合理、可误导模型”的对抗图像生成提供了直接参考。
- 局限：主要面向图像分类模型，不是 VLM/LVLM；摘要层面未显示其是否评估 VQA、captioning、grounding 或安全拒答等多模态任务；需要全文核查数据集、指标、攻击设置和结果强度。
- 和我们 idea 的关系：高度相关于“扩散模型生成自然/语义级对抗图像”的方法基础，但需要迁移到 VLM 场景；可作为自然性、语义保持和生成式攻击管线的先导工作。
- Citation Confidence: needs manual verification

## Paper: Content-based Unrestricted Adversarial Attack

- 研究问题：如何在不限制具体扰动形式的情况下生成既 photorealistic 又具备强攻击效果的 unrestricted adversarial examples，并避免以往方法因主观选择可修改内容而牺牲攻击自由度和性能。
- 方法：提出 Content-based Unrestricted Adversarial Attack 框架，将图像映射到表示自然图像的低维流形，并沿对抗方向优化；基于 Stable Diffusion 实现 Adversarial Content Attack (ACA)，生成具有多种 adversarial contents 的高迁移性 unrestricted adversarial examples。
- 实验对象/模型：面向深度视觉模型及防御方法进行攻击评估；摘要报告 ACA 在 normally trained models 和 defense methods 上相对 SOTA 攻击分别提升 13.3–50.4% 与 16.8–48.0%。
- 主要贡献：把 unrestricted attack 与自然图像流形/Stable Diffusion 结合；强调通过内容级变化提升 photorealism 与攻击性能；提供了从“像素扰动”转向“内容/语义扰动”的方法参考。
- 局限：主要讨论视觉分类/视觉模型攻击，未直接针对 VLM 的语言输出、跨模态推理或安全对齐；“内容变化”可能改变语义，后续需要严格区分语义保持编辑与真实语义改变；具体实验对象和指标需全文核查。
- 和我们 idea 的关系：与“自然、内容级、扩散生成的对抗图像”高度相关，可为 semantic/natural image edit 攻击提供方法借鉴；但我们需要进一步约束为 VLM 的 image-only 攻击，并加入 VQA/captioning/安全评估指标。
- Citation Confidence: needs manual verification

## Paper: Visual Adversarial Examples Jailbreak Aligned Large Language Models

- 研究问题：视觉输入是否会成为集成视觉能力的 aligned LLM/VLM 的安全弱点；视觉对抗样本是否能够绕过安全护栏，使模型响应本应拒绝的有害指令。
- 方法：构造视觉对抗样本作为 jailbreak 载体，利用视觉输入连续且高维的特性扩展攻击面；论文以案例研究展示单个视觉对抗样本可作为通用 jailbreak，使 aligned LLM 对多类有害指令产生响应。
- 实验对象/模型：面向集成视觉能力的 LLM/VLM；页面举例提到 Flamingo 和 GPT-4 代表了视觉集成趋势。具体实验模型、优化设置和 harmful instruction corpus 需全文核查。
- 主要贡献：明确提出视觉模态是多模态对齐系统的弱点；展示 visual adversarial examples 可将传统神经网络对抗脆弱性连接到 AI alignment 安全问题；指出一个视觉对抗样本可能跨越初始少量优化语料而泛化到更广泛有害指令。
- 局限：安全敏感内容较强，复现实验需要严格合规；攻击可能更偏传统 adversarial perturbation，而不是自然/扩散编辑；摘要层面未说明自然性、语义保持或人类感知质量如何评估。
- 和我们 idea 的关系：高度相关于 VLM/MLLM image-side jailbreak 安全风险，可作为安全任务动机和风险边界依据；但我们的方案应优先采用保守、 benign 的 correctness/VQA/captioning 失败，或将 jailbreak 作为受控未来工作。
- Citation Confidence: needs manual verification

## Paper: FigStep: Jailbreaking Large Vision-Language Models via Typographic Visual Prompts

- 研究问题：LVLM 是否过度依赖底层 LLM 的安全对齐；将禁止性文本内容转为图像中的排版/文字视觉提示，是否能绕过跨模态安全对齐。
- 方法：提出 FigStep，一种黑盒 jailbreak 算法；不直接输入有害文本指令，而是把被禁止内容转换为 typography image，通过视觉通道输入 LVLM；通过消融实验和语义嵌入分布分析解释其成功原因。
- 实验对象/模型：六个主流开源 LVLM；摘要报告平均攻击成功率为 82.50%；并与五种 text-only jailbreak 和四种 image-based jailbreak 比较。
- 主要贡献：提出简单低成本的 typographic visual prompt jailbreak；证明当前 LVLM 视觉嵌入安全对齐不足；提供强黑盒视觉 jailbreak baseline，并强调需要跨模态安全对齐技术。
- 局限：攻击形式依赖图像中文字/排版，不符合我们当前偏好的自然场景、语义保持扩散编辑；安全敏感内容需要谨慎处理；对商业模型和自然图像编辑攻击的适用性需要进一步验证。
- 和我们 idea 的关系：可作为 image-based jailbreak baseline 和安全风险参考，但与“自然、semantic-preserving diffusion edit”不同；适合在论文中作为对比类别：typographic visual prompt vs. natural diffusion-edited adversarial image。
- Citation Confidence: needs manual verification

## Paper: Red Teaming Visual Language Models

- 研究问题：VLM 在结合文本与视觉输入后，是否也会像 LLM 一样在红队测试中产生有害、不准确、不公平或隐私相关风险；当前开源 VLM 与 GPT-4V 在红队能力上差距如何。
- 方法：构建 RTVLM 红队数据集，覆盖 4 个方面：faithfulness、privacy、safety、fairness；包含 12 个子任务，例如 image misleading、multi-modal jailbreaking、face fairness 等；并使用 RTVLM 对 VLM 进行基准评估和红队对齐训练。
- 实验对象/模型：10 个 prominent open-sourced VLM，并与 GPT-4V 差距对比；还对 LLaVA-v1.5 使用 RTVLM 进行 supervised fine-tuning，观察红队对齐效果。
- 主要贡献：提出首个覆盖四类风险维度的 VLM red teaming benchmark RTVLM；发现开源 VLM 在不同程度上难以通过红队测试，且与 GPT-4V 最多存在 31% 性能差距；表明使用 RTVLM 做 SFT 可提升 LLaVA-v1.5 在 RTVLM、MM-hallu 等测试上的表现且不明显损害 MM-Bench。
- 局限：核心贡献是评测数据集与红队对齐，不是扩散生成攻击方法；不直接解决自然对抗图像生成；具体子任务定义、评分标准和可复现实验细节需要全文核查。
- 和我们 idea 的关系：为 VLM 安全评估维度、任务选择和 benchmark framing 提供依据；可帮助我们把 diffusion-edited adversarial images 放进 faithfulness/safety/multimodal jailbreak 等红队评估框架中。
- Citation Confidence: needs manual verification
