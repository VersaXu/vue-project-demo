import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { TurtleSoupPuzzle } from '@/config/turtleSoupPuzzles'

interface GameStats {
  totalGames: number
  totalQuestions: number
  solvedGames: number
  bestScore: number // 最少提问次数解谜
}

interface GameSession {
  puzzle: TurtleSoupPuzzle
  startTime: number
  endTime?: number
  questionsAsked: number
  solved: boolean
  usefulQuestions: number
  unrelatedQuestions: number
}

export const useTurtleSoupStore = defineStore('turtleSoup', () => {
  const currentGame = ref<TurtleSoupPuzzle | null>(null)
  const gameStats = ref<GameStats>({
    totalGames: 0,
    totalQuestions: 0,
    solvedGames: 0,
    bestScore: Infinity
  })
  const gameHistory = ref<GameSession[]>([])
  const currentSession = ref<GameSession | null>(null)

  const startNewGame = (puzzle: TurtleSoupPuzzle) => {
    currentGame.value = puzzle
    currentSession.value = {
      puzzle,
      startTime: Date.now(),
      questionsAsked: 0,
      solved: false,
      usefulQuestions: 0,
      unrelatedQuestions: 0
    }
    gameStats.value.totalGames++
  }

  const recordQuestion = (answerType: 'yes' | 'no' | 'irrelevant') => {
    if (currentSession.value) {
      currentSession.value.questionsAsked++
      gameStats.value.totalQuestions++
      
      if (answerType === 'yes') {
        currentSession.value.usefulQuestions++
      } else if (answerType === 'irrelevant') {
        currentSession.value.unrelatedQuestions++
      }
    }
  }

  const endGame = (solved: boolean) => {
    if (currentSession.value) {
      currentSession.value.endTime = Date.now()
      currentSession.value.solved = solved
      
      if (solved) {
        gameStats.value.solvedGames++
        if (currentSession.value.questionsAsked < gameStats.value.bestScore) {
          gameStats.value.bestScore = currentSession.value.questionsAsked
        }
      }
      
      gameHistory.value.push(currentSession.value)
      currentSession.value = null
    }
    currentGame.value = null
  }

  const resetStats = () => {
    gameStats.value = {
      totalGames: 0,
      totalQuestions: 0,
      solvedGames: 0,
      bestScore: Infinity
    }
    gameHistory.value = []
  }

  const getAverageQuestionsPerGame = () => {
    if (gameStats.value.totalGames === 0) return 0
    return Math.round(gameStats.value.totalQuestions / gameStats.value.totalGames * 10) / 10
  }

  const getSuccessRate = () => {
    if (gameStats.value.totalGames === 0) return 0
    return Math.round(gameStats.value.solvedGames / gameStats.value.totalGames * 100)
  }

  return {
    currentGame,
    gameStats,
    gameHistory,
    currentSession,
    startNewGame,
    recordQuestion,
    endGame,
    resetStats,
    getAverageQuestionsPerGame,
    getSuccessRate
  }
})