<template>
  <div class="p-6 bg-gray-900 rounded-lg shadow-lg">
    <h2 class="text-cyan-400 text-xl font-bold mb-4">資料表結構瀏覽</h2>
    <div v-if="loading" class="text-cyan-300">載入中...</div>
    <div v-if="error" class="text-red-400">{{ error }}</div>
    <ul v-if="schema.length" class="space-y-2">
      <li v-for="db in schema" :key="db.name">
        <div class="font-bold text-white">{{ db.name }}</div>
        <ul>
          <li v-for="table in db.tables" :key="table.name" class="ml-4">
            <span class="text-cyan-300">{{ table.name }}</span>
            <ul>
              <li v-for="col in table.columns" :key="col.name" class="ml-6 text-gray-300 text-sm">
                {{ col.name }} <span class="text-gray-400">({{ col.type }})</span>
              </li>
            </ul>
          </li>
        </ul>
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
const props = defineProps({ dbtype: String, connectionId: String })
const schema = ref([])
const loading = ref(false)
const error = ref('')
onMounted(async () => {
  loading.value = true
  try {
    const { data } = await axios.get('/api/db/schema', { params: { dbtype: props.dbtype, connectionId: props.connectionId } })
    if (data.status === 'success') schema.value = data.data
    else error.value = data.error || '載入失敗'
  } catch (e) {
    error.value = '載入失敗'
  }
  loading.value = false
})
</script>
