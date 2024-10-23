<script setup>

import MembersList from '@/components/MembersList.vue';
import { useUserStore, useDropdownStore } from '@/stores/counter.js'
import { onMounted, ref } from 'vue';

const userStore = useUserStore()
const dropdownStore = useDropdownStore()

const employees = ref([])
const isLoading = ref(true)
const employee = ref(null)
onMounted(async () => {
  dropdownStore.setDropdownActions()

  const storedToken = localStorage.getItem('token');

  if (storedToken) {
    employee.value = await userStore.tokenDecode(storedToken)
  } else {
    console.error("Aucun token trouvé.");
  }

  try {
    const response = await userStore.fetchUsers();
    employees.value = response
  } catch (error) {
    console.error("Erreur lors de la récupération des utilisateurs", error);
  } finally {
    isLoading.value = false
  }
})

</script>

<template>
  
  <div class="grid gap-4 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-2 xl:grid-cols-2">
    <MembersList v-if="!isLoading" title="All members of your company" titleColor="text-green-400" :items="employees"
      :headers="['Username', 'Email', 'Status']" :dropdownActions="dropdownStore.GMDropdownActions" />
    <div v-else class="text-center text-gray-500">Chargement des utilisateurs...</div>
  </div>

</template>