<template>
  <div class="p-6 bg-gray-900 rounded-lg shadow-lg">
    <h2 class="text-cyan-400 text-xl font-bold mb-4">SQL 查詢執行器</h2>
    <textarea v-model="sql" class="w-full bg-gray-800 text-white rounded p-2 mb-2" rows="5" placeholder="輸入 SQL 語法"></textarea>
    <button @click="runQuery" :disabled="loading" class="bg-cyan-500 hover:bg-cyan-400 text-white font-bold py-2 px-4 rounded">執行</button>
    <div v-if="loading" class="text-cyan-300 mt-2">查詢中...</div>
    <div v-if="error" class="text-red-400 mt-2">{{ error }}</div>
    <table v-if="result && result.columns" class="table-auto w-full mt-4 text-white">
      <thead>
        <tr>
          <th v-for="col in result.columns" :key="col" class="border-b border-cyan-700">{{ col }}</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="row in result.rows" :key="row[0]">
          <td v-for="cell in row" :key="cell" class="border-b border-gray-700">{{ cell }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'
const props = defineProps({ dbtype: String, connectionId: String })
const sql = ref('')
const loading = ref(false)
const error = ref('')
const result = ref(null)
const runQuery = async () => {
  error.value = ''
  if (!sql.value.trim()) {
    error.value = '請輸入 SQL 語法'
    return
  }
  loading.value = true
  try {
    const { data } = await axios.post('/api/db/query', { dbtype: props.dbtype, connectionId: props.connectionId, sql: sql.value })
    if (data.status === 'success') result.value = data.data
    else error.value = data.error || '查詢失敗'
  } catch (e) {
    error.value = '查詢失敗'
  }
  loading.value = false
}
</script>
