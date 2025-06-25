<template>
  <div class="p-6 bg-gray-900 rounded-lg shadow-lg">
    <h2 class="text-cyan-400 text-xl font-bold mb-4">程式碼生成工具</h2>
    <select v-model="table" class="model-selector mb-2">
      <option v-for="t in tables" :key="t" :value="t">{{ t }}</option>
    </select>
    <button @click="genCode" :disabled="!table || loading" class="bg-cyan-500 hover:bg-cyan-400 text-white font-bold py-2 px-4 rounded">產生程式碼</button>
    <pre v-if="code" class="bg-gray-800 text-green-300 p-4 mt-4 rounded">{{ code }}</pre>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
const props = defineProps({ connectionId: String })
const tables = ref(['users', 'orders'])
const table = ref('')
const code = ref('')
const loading = ref(false)
const genCode = async () => {
  loading.value = true
  const { data } = await axios.post('/api/db/gen_code', { connectionId: props.connectionId, table: table.value, language: 'typescript' })
  code.value = data.data.code
  loading.value = false
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
