<script setup>

import { Search } from 'lucide-vue-next'
import { Card, CardContent } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { ScrollArea } from '@/components/ui/scroll-area'
import HeaderTable from '@/components/HeaderTable.vue'
import MembersList from '@/components/MembersList.vue'

import { useUserStore, useTeamStore, useDropdownStore } from '@/stores/counter.js'
import { useRoute } from 'vue-router';
import { ref, onMounted, watch } from 'vue';

const teamStore = useTeamStore()
const userStore = useUserStore()
const dropdownStore = useDropdownStore()

const team = ref(null);
const isLoading = ref(true);
const employees = ref([]);

const route = useRoute();

onMounted(async () => {
  await loadData()
})

watch(
  [() => route.params.id, () => team],
  async () => {
    await loadData();
  }
);
async function loadData() {
  const id = route.params.id
  dropdownStore.setDropdownActions()

  try {
    const response = await teamStore.fetchTeamById(id);
    team.value = response;
    const responseEmployees = await userStore.fetchUsers();
    employees.value = responseEmployees

  } catch (error) {
    console.error("Erreur lors de la récupération des utilisateurs", error);
  } finally {
    isLoading.value = false;
  }
}

</script>

<template>
  <div class="grid gap-4 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-2 xl:grid-cols-4">
    <MembersList v-if="!isLoading && team" :title="team.name" titleColor="text-green-400" :teamID="team.id"
      :items="team.users" :headers="['Username', 'Email', 'Status']"
      :dropdownActions="dropdownStore.teamDropdownActions" />
    <Card class="sm:col-span-2">
      <HeaderTable title="Members List" description="Add someone to your team." />
      <CardContent>
        <div class="w-full flex-1 mb-2">
          <form>
            <div class="relative">
              <Search class="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input type="search" placeholder="Search..."
                class="w-full appearance-none bg-background pl-8 shadow-none md:w-2/3 lg:w-1/3" />
            </div>
          </form>
        </div>
        <ScrollArea class="h-72 rounded-md border">
          <MembersList v-if="!isLoading" :isTeam=false :items="employees" :teamID="team.id"
            :headers="['Username', 'Email', 'Status']" :dropdownActions="dropdownStore.memberDropdownActions" />
        </ScrollArea>
      </CardContent>
    </Card>
  </div>
</template>