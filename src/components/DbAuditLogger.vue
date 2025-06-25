<template>
  <div class="p-6 bg-gray-900 rounded-lg shadow-lg">
    <h2 class="text-cyan-400 text-xl font-bold mb-4">異動日誌</h2>
    <table v-if="logs.length" class="table-auto w-full text-white">
      <thead>
        <tr>
          <th>時間</th>
          <th>用戶</th>
          <th>表格</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="l in logs" :key="l.id">
          <td>{{ l.time }}</td>
          <td>{{ l.user }}</td>
          <td>{{ l.table }}</td>
          <td>{{ l.action }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
const props = defineProps({ connectionId: String })
const logs = ref([])
onMounted(async () => {
  const { data } = await axios.get('/api/db/audit-log', { params: { connectionId: props.connectionId } })
  logs.value = data.data
})
</script>
