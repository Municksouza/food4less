// Destrava autoplay e guarda o áudio
let unlockedNotificationAudio = null
let activeAudio = null

export function unlockAudioForAutoplay(soundUrl = "/sounds/alert-loop.mp3") {
  const audio = new Audio(soundUrl)
  audio.loop = true
  audio.play()
       .then(() => {
         audio.pause()
         audio.currentTime = 0
         unlockedNotificationAudio = audio
         console.log("🔓 Audio unlocked for future autoplay")
       })
       .catch(err => console.warn("⚠️ Audio unlock failed:", err.message))
}

export function playNotificationSound() {
  if (!unlockedNotificationAudio) {
    console.warn("🔕 Audio not enabled by the user")
    return
  }
  if (activeAudio && activeAudio !== unlockedNotificationAudio) {
    activeAudio.pause()
    activeAudio.currentTime = 0
  }
  unlockedNotificationAudio.currentTime = 0
  unlockedNotificationAudio.play().catch(() => {})
  activeAudio = unlockedNotificationAudio
}

export function stopGlobalAudio() {
  if (activeAudio) {
    activeAudio.pause()
    activeAudio.currentTime = 0
    activeAudio = null
  }
}