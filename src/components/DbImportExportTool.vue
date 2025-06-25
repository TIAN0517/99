<template>
  <div class="p-6 bg-gray-900 rounded-lg shadow-lg">
    <h2 class="text-cyan-400 text-xl font-bold mb-4">匯入/匯出工具</h2>
    <form @submit.prevent="handleImport" class="mb-4">
      <input type="file" @change="onFileChange" class="mb-2" />
      <button type="submit" :disabled="loading" class="bg-cyan-500 hover:bg-cyan-400 text-white font-bold py-2 px-4 rounded">匯入</button>
    </form>
    <div v-if="importMsg" class="text-green-400">{{ importMsg }}</div>
    <div class="mt-4">
      <label class="block text-white mb-1">匯出格式</label>
      <select v-model="exportFormat" class="model-selector mb-2">
        <option value="csv">CSV</option>
        <option value="json">JSON</option>
        <option value="sql">SQL</option>
      </select>
      <button @click="handleExport" class="bg-cyan-500 hover:bg-cyan-400 text-white font-bold py-2 px-4 rounded">匯出</button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'
const props = defineProps({ connectionId: String })
const file = ref(null)
const importMsg = ref('')
const exportFormat = ref('csv')
const loading = ref(false)
const onFileChange = e => file.value = e.target.files[0]
const handleImport = async () => {
  if (!file.value) return
  loading.value = true
  const formData = new FormData()
  formData.append('file', file.value)
  formData.append('connectionId', props.connectionId)
  const { data } = await axios.post('/api/db/import', formData)
  importMsg.value = data.msg || '匯入完成'
  loading.value = false
}
const handleExport = () => {
  window.open(`/api/db/export?connectionId=${props.connectionId}&format=${exportFormat.value}`)
}
</script>

<style scoped>
.model-selector {
  background: #1e1e1e;
  color: #fff;
  border: 1px solid #00d4ff;
  border-radius: 6px;
  box-shadow: 0 0 8px rgba(0, 255, 255, 0.3);
  padding: 8px 12px;
  outline: none;
  appearance: none;
}
</style>
