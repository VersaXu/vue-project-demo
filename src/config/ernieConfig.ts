export const QWEN_CONFIG = {
  API_KEY: 'sk-446fc4f4977b4584a318ccc235cf2fd1',
  BASE_URL: 'https://dashscope.aliyuncs.com/compatible-mode/v1',
  MODEL: 'qwen-turbo', // 通义千问-flash模型的兼容模式名称
}

// 默认谜题，当API不可用时使用
export const DEFAULT_PUZZLES = [
  {
    question: '一个人走进餐厅，点了一份海龟汤，喝了一口后，突然明白了什么，然后自杀了。为什么？',
    answer:
      '他曾经和朋友在海上遇难，朋友为了救他牺牲了自己。后来他在餐厅喝到海龟汤，发现味道和当时朋友说的"海龟汤"一样，意识到自己吃的是朋友的肉。',
    hint: '和朋友在海上遇难有关',
  },
  {
    question:
      '一个男人住在10楼，每天他都会乘电梯到1楼去上班。但回来时，他总是乘电梯到7楼，然后爬楼梯到10楼。为什么？',
    answer: '他是个矮个子，只能按到7楼的按钮，够不到10楼的按钮。',
    hint: '和他的身高有关',
  },
]
