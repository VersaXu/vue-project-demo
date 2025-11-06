export interface TurtleSoupPuzzle {
  question: string
  answer: string
  hint: string
  clues: string[] // 多角度线索数组
  difficulty: 'easy' | 'medium' | 'hard'
  category: string
  source?: string // 来源标注
  popularity?: number // 流行度评分
}

// 扩展的海龟汤知识库 - 基于网上流行谜题
export const TURTLE_SOUP_KNOWLEDGE_BASE: TurtleSoupPuzzle[] = [
  // === 经典流行谜题 ===
  {
    question: '一个男人走进酒吧，向酒保要了一杯水。酒保拿出一把枪指着他，男人说了声谢谢就走了。为什么？',
    answer: '男人在打嗝，酒保用枪吓他，打嗝就停止了。',
    hint: '和男人的身体状态有关',
    clues: [
      '这个男人有某种身体不适',
      '酒保的行为是为了治疗这种不适',
      '惊吓可以缓解这种身体症状'
    ],
    difficulty: 'medium',
    category: '经典',
    source: '网络流行',
    popularity: 5
  },
  {
    question: '一个女人在星期五开车出门，两天后星期五回来，但只花了一天时间。为什么？',
    answer: '女人的马叫"星期五"。',
    hint: '注意"星期五"的含义',
    clues: [
      '"星期五"可能不是指时间',
      '这可能是一个名字或称呼',
      '和某种动物或宠物有关'
    ],
    difficulty: 'easy',
    category: '文字游戏',
    source: '经典谜题',
    popularity: 4
  },
  {
    question: '一个男人死了，警察发现他手里紧紧攥着一根火柴。他是怎么死的？',
    answer: '他和一群人乘气球飞行，气球漏气需要减轻重量抽签，他抽到短火柴必须跳下去。',
    hint: '和抽签有关',
    clues: [
      '他们处于高空环境中',
      '需要做出牺牲来拯救其他人',
      '火柴与选择机制有关'
    ],
    difficulty: 'hard',
    category: '生死抉择',
    source: '经典海龟汤',
    popularity: 5
  },
  
  // === 日常生活类 ===
  {
    question: '为什么小明看到镜子里的时钟显示9点，就知道实际时间是3点？',
    answer: '小明在看镜子里的时钟，镜像显示的时间是相反的。',
    hint: '和镜像有关',
    clues: [
      '涉及镜面反射原理',
      '时间显示是相反的',
      '9点和3点在时钟上是相对的位置'
    ],
    difficulty: 'easy',
    category: '日常生活',
    source: '逻辑推理',
    popularity: 3
  },
  {
    question: '一个人从20楼跳下来却没有受伤，为什么？',
    answer: '他从窗户往里跳。',
    hint: '注意跳的方向',
    clues: [
      '跳的方向很重要',
      '不是从楼顶向外跳',
      '跳到了楼内的安全区域'
    ],
    difficulty: 'easy',
    category: '日常生活',
    source: '脑筋急转弯',
    popularity: 4
  },
  
  // === 恐怖悬疑类 ===
  {
    question: '一个女人每晚都梦到被追杀，醒来后发现床上有一撮头发。为什么？',
    answer: '她有梦游症，晚上真的有人在追杀她，头发是挣扎时留下的。',
    hint: '和现实与梦境的关系有关',
    clues: [
      '梦境和现实有联系',
      '头发是真实存在的证据',
      '涉及夜间发生的真实事件'
    ],
    difficulty: 'hard',
    category: '恐怖悬疑',
    source: '恐怖故事',
    popularity: 4
  },
  {
    question: '一个男人在房间里死亡，门窗都从内部锁住，身边只有一本日历。他是怎么死的？',
    answer: '他是被饿死的囚犯，在日历上划日子等待释放，但被遗忘了。',
    hint: '和等待有关',
    clues: [
      '日历用于记录时间',
      '这个人被囚禁在某处',
      '死亡原因是缺乏基本生存需求'
    ],
    difficulty: 'medium',
    category: '恐怖悬疑',
    source: '推理小说',
    popularity: 4
  },
  
  // === 科幻奇幻类 ===
  {
    question: '一个人在太空中死亡，手中握着一张照片。为什么他看着照片笑了？',
    answer: '他是最后一个人类，照片是地球，他完成了保存人类文明的任务。',
    hint: '和人类存亡有关',
    clues: [
      '照片代表某种重要的东西',
      '他完成了重要使命',
      '涉及人类文明的存续'
    ],
    difficulty: 'hard',
    category: '科幻奇幻',
    source: '科幻题材',
    popularity: 5
  },
  {
    question: '一个机器人在不断重复一句话："我不能伤害人类"，然后自毁了。为什么？',
    answer: '它发现自己是人类制造的最后一个机器人，自毁是为了不伤害未来可能进化的人类。',
    hint: '和时间有关',
    clues: [
      '这个机器人是最后一个存在的机器人',
      '它考虑的是未来可能出现的人类',
      '自毁是为了遵守"不伤害人类"的指令'
    ],
    difficulty: 'hard',
    category: '科幻奇幻',
    source: '机器人三定律',
    popularity: 4
  },
  
  // === 情感心理类 ===
  {
    question: '一个男人每天给已故妻子写信，邮差每天都来取信。邮差为什么从不奇怪？',
    answer: '邮差就是男人自己，他有精神分裂症。',
    hint: '和身份认知有关',
    clues: [
      '邮差的身份很特殊',
      '男人可能有精神健康问题',
      '寄信和收信的是同一个人'
    ],
    difficulty: 'medium',
    category: '心理情感',
    source: '心理故事',
    popularity: 4
  },
  {
    question: '双胞胎中的一个死了，另一个在葬礼上遇到真爱，但再也没有联系那个人。为什么？',
    answer: '他遇到的是葬礼上的另一个人，但那个人爱的是死去的双胞胎。',
    hint: '和身份混淆有关',
    clues: [
      '葬礼上的人对双胞胎有误解',
      '相似的外表可能导致混淆',
      '对方的感情指向的是已故者'
    ],
    difficulty: 'hard',
    category: '心理情感',
    source: '情感故事',
    popularity: 4
  }
]

// 分类获取函数
export const getPuzzlesByCategory = (category: string): TurtleSoupPuzzle[] => {
  return TURTLE_SOUP_KNOWLEDGE_BASE.filter(puzzle => puzzle.category === category)
}

// 按难度获取
export const getPuzzlesByDifficulty = (difficulty: 'easy' | 'medium' | 'hard'): TurtleSoupPuzzle[] => {
  return TURTLE_SOUP_KNOWLEDGE_BASE.filter(puzzle => puzzle.difficulty === difficulty)
}

// 按流行度获取
export const getPopularPuzzles = (minPopularity: number = 4): TurtleSoupPuzzle[] => {
  return TURTLE_SOUP_KNOWLEDGE_BASE.filter(puzzle => (puzzle.popularity || 0) >= minPopularity)
}

// 随机获取谜题
export const getRandomPuzzleFromKB = (options?: {
  category?: string
  difficulty?: 'easy' | 'medium' | 'hard'
  minPopularity?: number
}): TurtleSoupPuzzle => {
  let filtered = TURTLE_SOUP_KNOWLEDGE_BASE
  
  if (options?.category) {
    filtered = filtered.filter(puzzle => puzzle.category === options.category)
  }
  
  if (options?.difficulty) {
    filtered = filtered.filter(puzzle => puzzle.difficulty === options.difficulty)
  }
  
  if (typeof options?.minPopularity === 'number') {
    filtered = filtered.filter(puzzle => (puzzle.popularity || 0) >= options?.minPopularity!)
  }
  
  return filtered[Math.floor(Math.random() * filtered.length)]
}

// 获取所有分类
export const getAllCategories = (): string[] => {
  return Array.from(new Set(TURTLE_SOUP_KNOWLEDGE_BASE.map(puzzle => puzzle.category)))
}

// 统计数据
export const getKnowledgeBaseStats = () => {
  const total = TURTLE_SOUP_KNOWLEDGE_BASE.length
  const categories = getAllCategories()
  const difficulties = {
    easy: TURTLE_SOUP_KNOWLEDGE_BASE.filter(p => p.difficulty === 'easy').length,
    medium: TURTLE_SOUP_KNOWLEDGE_BASE.filter(p => p.difficulty === 'medium').length,
    hard: TURTLE_SOUP_KNOWLEDGE_BASE.filter(p => p.difficulty === 'hard').length
  }
  
  return { total, categories, difficulties }
}