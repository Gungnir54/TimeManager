<script setup>
import MenuItems from './MenuItems.vue';
import { Boxes, BookUser, Clock, Users, LineChart, UserPlus, LayoutDashboard, ChevronDown } from 'lucide-vue-next';
import { Badge } from '@/components/ui/badge';
import { DropdownMenu, DropdownMenuContent, DropdownMenuTrigger } from '@/components/ui/dropdown-menu';
import { Button } from '@/components/ui/button';

import { useRoute, useRouter, onBeforeRouteUpdate } from 'vue-router';
import { useUserStore } from '@/stores/counter.js';
import { ref, onMounted, computed  } from 'vue';

const userStore = useUserStore();
const route = useRoute();
const router = useRouter();
const connectedUserTeams = ref([]);

const myTeamLabel = computed(() => {
  return connectedUserTeams.value.length > 1 ? 'MyTeams' : 'MyTeam';
});

const menuItems = ref([
  { href: '/dashboard', label: 'Dashboard', icon: LayoutDashboard, isActive: false,},
  { href: '/myteam', label: myTeamLabel, icon: BookUser, isActive: false, teamsDropdown: true, },
  { href: '/clock-manager', label: 'ClockManager', icon: Clock, isActive: false, },
  { href: '/chart-manager', label: 'ChartManager', icon: LineChart, isActive: false, },
  { href: '/members', label: 'Members', icon: Users, badge: { variant: 'green', text: 6 }, isActive: false,},
  { href: '/create', label: 'Create', icon: UserPlus, isActive: false,},
  { href: '/manage-teams', label: 'ManageTeams', icon: Boxes, isActive: false,}
]);

// Fonction pour mettre à jour l'élément actif
const setActiveItem = (currentPath) => {
  menuItems.value.forEach(item => {
    item.isActive = item.href === currentPath;
  });
};

// Met à jour l'état des items sur la route actuelle lors de l'initialisation
setActiveItem(route.path);

// Gérer les changements de route
onBeforeRouteUpdate((to, from, next) => {
  setActiveItem(to.path);
  next();
});

// Fonction qui gère le clic et met à jour immédiatement l'état actif
const handleItemClick = (href) => {
  setActiveItem(href);
  router.push(href);
};

const handleTeamClick = (id) => {
  router.push({ name: 'myTeam', params: { id } })
};

const loadConnectedUser = async () => {
  const storedToken = localStorage.getItem('token');
  if (storedToken) {
    const decodedToken = await userStore.tokenDecode(storedToken);
    const response = await userStore.fetchUserById(decodedToken.user_id);
    connectedUserTeams.value = response.teams || []
  }
};

onMounted(async () => {
  await loadConnectedUser();
});
</script>

<template>
  <nav class="grid items-start px-2 text-sm font-medium lg:px-4">
    <MenuItems v-for="(item, index) in menuItems" :key="index" :href="item.href" :label="item.label"
      :isActive="item.isActive" :useDropdown="item.teamsDropdown" @item-click="handleItemClick">
      
      <template #icon>
        <component :is="item.icon" class="h-4 w-4" />
      </template>

      <template v-if="item.teamsDropdown">
        <DropdownMenu>
          <DropdownMenuTrigger>
            <div class="flex items-center cursor-pointer">
              <ChevronDown class="ml-2 h-4 w-4 hover:text-green-400" />
            </div>
          </DropdownMenuTrigger>
          <DropdownMenuContent>
            <div v-for="team in connectedUserTeams" :key="team.id">
              <Button variant="ghost" class="w-full" @click="handleTeamClick(team.id)">
                {{ team.name }}
              </Button>
            </div>
          </DropdownMenuContent>
        </DropdownMenu>
      </template>

      <template #badge v-if="item.badge">
        <Badge :variant="item.badge.variant"
          class="ml-auto flex h-6 w-6 shrink-0 items-center justify-center rounded-full">
          {{ item.badge.text }}
        </Badge>
      </template>
    </MenuItems>
  </nav>
</template>
