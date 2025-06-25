<template>
  <div class="p-6 bg-gray-900 rounded-lg shadow-lg">
    <h2 class="text-cyan-400 text-xl font-bold mb-4">用戶與權限管理</h2>
    <div v-if="loading" class="text-cyan-300">載入中...</div>
    <div v-if="error" class="text-red-400">{{ error }}</div>
    <table v-if="users.length" class="table-auto w-full text-white">
      <thead>
        <tr>
          <th>用戶</th>
          <th>角色</th>
          <th>權限</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="u in users" :key="u.username">
          <td>{{ u.username }}</td>
          <td>{{ u.roles.join(', ') }}</td>
          <td>{{ u.privileges.join(', ') }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
const props = defineProps({ dbtype: String, connectionId: String })
const users = ref([])
const loading = ref(false)
const error = ref('')
onMounted(async () => {
  loading.value = true
  try {
    const { data } = await axios.get('/api/db/permissions', { params: { dbtype: props.dbtype, connectionId: props.connectionId } })
    if (data.status === 'success') users.value = data.data
    else error.value = data.error || '載入失敗'
  } catch (e) {
    error.value = '載入失敗'
  }
  loading.value = false
})
</script>
