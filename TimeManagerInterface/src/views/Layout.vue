<!-- layout.vue -->
<script setup>

import Menu from '@/components/SideBar/Menu.vue';
import Logo from '@/components/Header/Logo.vue';
import Header from '@/components/Header/Header.vue';
import { ref, onMounted } from 'vue';
import { useUserStore } from '@/stores/counter.js';

const userStore = useUserStore();
const employee = ref(null);
const isLoading = ref(true);

onMounted(async () => {
  const storedToken = localStorage.getItem('token');
  if (storedToken) {
    employee.value = await userStore.tokenDecode(storedToken);
  }
  isLoading.value = false;
});
</script>

<template>
  <div class="grid min-h-screen w-full md:grid-cols-[220px_1fr] lg:grid-cols-[280px_1fr]">
    <!-- Sidebar with Logo and Menu -->
    <div class="hidden border-r bg-muted/40 md:block">
      <div class="flex h-full max-h-screen flex-col gap-2">
        <Logo />
        <div class="flex-1">
          <Menu />
        </div>
      </div>
    </div>

    <!-- Main Content Area -->
    <div class="flex flex-col">
      <!-- Header -->
      <Header v-if="employee" :employee="employee" />

      <!-- Dynamic Content Loaded via router-view -->
      <main class="grid flex-1 items-start m-8 gap-4 p-4 sm:px-6 sm:py-0 md:gap-8 lg:grid-cols-3 xl:grid-cols-3">
        <div class="grid auto-rows-max items-start gap-4 md:gap-8 lg:col-span-4">


          <router-view />


        </div>
      </main>

    </div>
  </div>
</template>
