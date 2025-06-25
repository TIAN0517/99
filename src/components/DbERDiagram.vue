<template>
  <div class="p-6 bg-gray-900 rounded-lg shadow-lg">
    <h2 class="text-cyan-400 text-xl font-bold mb-4">ER 關聯圖</h2>
    <div v-if="diagram" v-html="diagram" class="bg-gray-800 p-4 rounded"></div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
const props = defineProps({ connectionId: String })
const diagram = ref('')
onMounted(async () => {
  const { data } = await axios.get('/api/db/erd', { params: { connectionId: props.connectionId } })
  diagram.value = `<pre class='text-white'>${data.data.mermaid}</pre>`
})
</script>
