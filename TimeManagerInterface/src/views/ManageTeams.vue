<script setup>

import MembersList from '@/components/MembersList.vue'
import { useTeamStore, useDropdownStore, useUserStore } from '@/stores/counter'
import { onMounted, ref } from 'vue';


const teamStore = useTeamStore()
const dropdownStore = useDropdownStore()
const userStore = useUserStore()

const employee = ref(null)
const teams = ref([]);

const isLoading = ref(true)
onMounted(async () => {
  dropdownStore.setDropdownActions()

  const storedToken = localStorage.getItem('token');

  if (storedToken) {
    employee.value = await userStore.tokenDecode(storedToken)
  } else {
    console.error("Aucun token trouvé.");
  }

  try {
    const response = await teamStore.fetchTeams();
    teams.value = response
  } catch (error) {
    console.error("Erreur lors de la récupération des utilisateurs", error);
  } finally {
    isLoading.value = false
  }
})
</script>

<template>
  <div class="grid gap-4 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-2 xl:grid-cols-4">
    <MembersList v-if="!isLoading" v-for="(team, index) in teams" :key="index" :title="team.name"
      titleColor="text-green-400" :items="team.users" :headers="['Username', 'Email', 'Status']"
      :dropdownActions="dropdownStore.teamDropdownActions" :teamID="team.id"/>
  </div>

</template>