<template>
  <div class="p-6 bg-gray-900 rounded-lg shadow-lg max-w-md mx-auto">
    <h2 class="text-cyan-400 text-xl font-bold mb-4">資料庫連線管理</h2>
    <form @submit.prevent="handleConnect" class="space-y-4">
      <div>
        <label class="block text-white">資料庫類型</label>
        <select v-model="form.type" class="model-selector w-full mt-1">
          <option value="mysql">MySQL</option>
          <option value="mssql">SQL Server</option>
        </select>
      </div>
      <div>
        <label class="block text-white">主機</label>
        <input v-model="form.host" class="w-full bg-gray-800 text-white rounded px-3 py-2" required />
      </div>
      <div>
        <label class="block text-white">埠號</label>
        <input v-model="form.port" type="number" class="w-full bg-gray-800 text-white rounded px-3 py-2" required />
      </div>
      <div>
        <label class="block text-white">帳號</label>
        <input v-model="form.user" class="w-full bg-gray-800 text-white rounded px-3 py-2" required />
      </div>
      <div>
        <label class="block text-white">密碼</label>
        <input v-model="form.password" type="password" class="w-full bg-gray-800 text-white rounded px-3 py-2" required />
      </div>
      <div>
        <label class="block text-white">資料庫名稱</label>
        <input v-model="form.dbname" class="w-full bg-gray-800 text-white rounded px-3 py-2" required />
      </div>
      <button type="submit" :disabled="loading" class="w-full bg-cyan-500 hover:bg-cyan-400 text-white font-bold py-2 rounded transition">
        {{ loading ? '連線中...' : '連線測試' }}
      </button>
    </form>
    <div v-if="error" class="text-red-400 mt-2">{{ error }}</div>
    <div v-if="success" class="text-green-400 mt-2">連線成功！</div>
    <div v-if="connections.length" class="mt-6">
      <h3 class="text-cyan-300 mb-2">已儲存連線</h3>
      <div class="flex flex-wrap gap-2">
        <button v-for="c in connections" :key="c.id"
          class="bg-gray-800 text-white px-3 py-1 rounded hover:bg-cyan-700"
          @click="$emit('switch', c)">
          {{ c.type }}@{{ c.host }}:{{ c.port }}/{{ c.dbname }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'
const form = ref({
  type: 'mysql', host: '', port: 3306, user: '', password: '', dbname: ''
})
const loading = ref(false)
const error = ref('')
const success = ref(false)
const connections = ref([])

const handleConnect = async () => {
  error.value = ''
  success.value = false
  if (!form.value.host || !form.value.user || !form.value.password || !form.value.dbname) {
    error.value = '所有欄位皆必填'
    return
  }
  loading.value = true
  try {
    const { data } = await axios.post('/api/db/connect', form.value)
    if (data.status === 'success') {
      success.value = true
      connections.value.push({ ...form.value, id: Date.now() })
    } else {
      error.value = data.error || '連線失敗'
    }
  } catch (e) {
    error.value = '連線失敗'
  }
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
