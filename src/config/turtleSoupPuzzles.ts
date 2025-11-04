export interface TurtleSoupPuzzle {
  question: string
  answer: string
  hint: string
  difficulty: 'easy' | 'medium' | 'hard'
  category: string
  source?: string
  popularity?: number
}

// 合并新旧谜题库，保留原有的同时添加新的
export const TURTLE_SOUP_PUZZLES: TurtleSoupPuzzle[] = [
  // 原有谜题
  {
    question: '一个人走进餐厅，点了一份海龟汤，喝了一口后，突然明白了什么，然后自杀了。为什么？',
    answer:
      '他曾经和朋友在海上遇难，朋友为了救他牺牲了自己。后来他在餐厅喝到海龟汤，发现味道和当时朋友说的"海龟汤"一样，意识到自己吃的是朋友的肉。',
    hint: '和朋友在海上遇难有关',
    difficulty: 'medium',
    category: '经典',
    source: '经典海龟汤',
    popularity: 5,
  },
  {
    question:
      '一个男人住在10楼，每天他都会乘电梯到1楼去上班。但回来时，他总是乘电梯到7楼，然后爬楼梯到10楼。为什么？',
    answer: '他是个矮个子，只能按到7楼的按钮，够不到10楼的按钮。',
    hint: '和他的身高有关',
    difficulty: 'easy',
    category: '日常生活',
    source: '逻辑推理',
    popularity: 4,
  },
  {
    question: '一个男人在沙漠中死亡，身边有一个未打开的包裹。为什么他没有打开包裹？',
    answer: '他是跳伞运动员，降落伞没有打开。那个包裹就是降落伞包。',
    hint: '和降落有关',
    difficulty: 'medium',
    category: '意外事件',
    source: '经典谜题',
    popularity: 4,
  },
  {
    question:
      '一个女人听到敲门声，打开门却没有人。第二天又听到敲门声，开门还是没有人。第三天她听到敲门声后直接报警，为什么？',
    answer:
      '她住在高层公寓，敲门声来自楼上邻居的敲门，但每次她开门时邻居已经进屋。第三天她意识到敲门声来自楼上，但楼上邻居正在住院，所以报警。',
    hint: '和声音来源有关',
    difficulty: 'hard',
    category: '推理',
    source: '推理故事',
    popularity: 4,
  },
  {
    question: '一个盲人走进一家餐厅，点了一份牛排。吃完后他站起来，走出餐厅，然后自杀了。为什么？',
    answer:
      '他曾经是猎人，意外射中了同伴。后来失明后，在餐厅吃到野味，通过味道认出这是人肉，意识到自己一直吃的是人肉。',
    hint: '和肉的味道有关',
    difficulty: 'hard',
    category: '心理',
    source: '心理故事',
    popularity: 4,
  },
  {
    question: '两个人一起走进大楼，一个人活着出来，另一个人死了。为什么？',
    answer: '他们是孕妇和胎儿，孕妇活着走出医院，胎儿在分娩过程中死亡。',
    hint: '和医院有关',
    difficulty: 'medium',
    category: '医疗',
    source: '医疗故事',
    popularity: 3,
  },
  {
    question:
      '一个男人看着一张照片说："我没有兄弟，但这个男人的父亲是我父亲的儿子。"照片中的人是谁？',
    answer: '照片中的人是他的儿子。',
    hint: '注意"我父亲的儿子"这个表述',
    difficulty: 'easy',
    category: '逻辑',
    source: '逻辑谜题',
    popularity: 3,
  },
  {
    question: '一个女人在房间里死亡，身边只有水和玻璃碎片。她是怎么死的？',
    answer: '她是金鱼，鱼缸被打碎，缺水而死。',
    hint: '注意"身边只有水和玻璃碎片"',
    difficulty: 'medium',
    category: '动物',
    source: '脑筋急转弯',
    popularity: 3,
  },
  {
    question: '一个男人在雪地中死亡，身边有一个背包。为什么他没有使用背包里的东西？',
    answer: '他是圣诞老人，背包里是礼物，但他心脏病发作死亡。',
    hint: '和时间有关',
    difficulty: 'easy',
    category: '节日',
    source: '节日故事',
    popularity: 3,
  },
  {
    question: '两个人一起过桥，桥断了，一个人死亡，一个人活着。为什么？',
    answer: '他们是连体婴儿，手术分离时一个死亡一个存活。',
    hint: '和身体连接有关',
    difficulty: 'hard',
    category: '医疗',
    source: '医疗故事',
    popularity: 3,
  },

  // 新增流行谜题
  {
    question:
      '一个男人走进酒吧，向酒保要了一杯水。酒保拿出一把枪指着他，男人说了声谢谢就走了。为什么？',
    answer: '男人在打嗝，酒保用枪吓他，打嗝就停止了。',
    hint: '和男人的身体状态有关',
    difficulty: 'medium',
    category: '经典',
    source: '网络流行',
    popularity: 5,
  },
  {
    question: '一个女人在星期五开车出门，两天后星期五回来，但只花了一天时间。为什么？',
    answer: '女人的马叫"星期五"。',
    hint: '注意"星期五"的含义',
    difficulty: 'easy',
    category: '文字游戏',
    source: '经典谜题',
    popularity: 4,
  },
  {
    question: '一个男人死了，警察发现他手里紧紧攥着一根火柴。他是怎么死的？',
    answer: '他和一群人乘气球飞行，气球漏气需要减轻重量抽签，他抽到短火柴必须跳下去。',
    hint: '和抽签有关',
    difficulty: 'hard',
    category: '生死抉择',
    source: '经典海龟汤',
    popularity: 5,
  },
]

export const getRandomPuzzle = (difficulty?: 'easy' | 'medium' | 'hard'): TurtleSoupPuzzle => {
  let filteredPuzzles = TURTLE_SOUP_PUZZLES
  if (difficulty) {
    filteredPuzzles = TURTLE_SOUP_PUZZLES.filter((puzzle) => puzzle.difficulty === difficulty)
  }
  return filteredPuzzles[Math.floor(Math.random() * filteredPuzzles.length)]
}

export const getPuzzlesByCategory = (category: string): TurtleSoupPuzzle[] => {
  return TURTLE_SOUP_PUZZLES.filter((puzzle) => puzzle.category === category)
}
