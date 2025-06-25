<template>
  <div class="p-6 bg-gray-900 rounded-lg shadow-lg">
    <h2 class="text-cyan-400 text-xl font-bold mb-4">即時備份/快照</h2>
    <button @click="backup" :disabled="loading" class="bg-cyan-500 hover:bg-cyan-400 text-white font-bold py-2 px-4 rounded">執行備份</button>
    <div v-if="link" class="mt-4">
      <a :href="link" class="text-green-400 underline" download>下載備份檔案</a>
    </div>
    <div v-if="loading" class="text-cyan-300 mt-2">備份中...</div>
  </div>
</template>
<script setup>
import { ref } from 'vue'
import axios from 'axios'
const props = defineProps({ connectionId: String })
const link = ref('')
const loading = ref(false)
const backup = async () => {
  loading.value = true
  const { data } = await axios.post('/api/db/backup', { connectionId: props.connectionId })
  link.value = data.url
  loading.value = false
}
</script>
