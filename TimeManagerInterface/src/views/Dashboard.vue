<script setup>

import IDcard from '@/components/UserInformations/IDcard.vue'
import Attendances from '@/components/UserInformations/Attendances.vue'
import Filter from '@/components/UserInformations/Filter.vue'

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'

import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from '@/components/ui/tabs'

import { useUserStore } from '@/stores/counter.js'
import { onMounted, ref, watch } from 'vue';
import { useRoute } from 'vue-router';
const userStore = useUserStore();
const route = useRoute();
const employee = ref(null);
const isLoading = ref(true);

onMounted(async () => {
  await loadEmployeeData();
});

watch(
  () => route.params.id,
  async () => {
    await loadEmployeeData();
  }
);

async function loadEmployeeData() {
  const employeeId = route.params.id;
  if (employeeId) {
    employee.value = await userStore.fetchUserById(employeeId);
  } else {
    const storedToken = localStorage.getItem('token');
    if (storedToken) {
      employee.value = await userStore.tokenDecode(storedToken);
    }
  }
  isLoading.value = false;
}

</script>

<template>
  <div class="grid gap-4 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-2 xl:grid-cols-4">
    <IDcard v-if="employee" :employee="employee" />
    <Attendances />
  </div>

  <Tabs default-value="weekly">
    <div class="flex items-center">
      <TabsList>
        <TabsTrigger value="daily">
          Daily
        </TabsTrigger>
        <TabsTrigger value="weekly">
          Weekly
        </TabsTrigger>
      </TabsList>
      <Filter />
    </div>
    
    <Card>
      <CardHeader class="px-7">
        <CardTitle>Your WorkingTimes</CardTitle>
        <CardDescription>
          Here you can check your daily and weekly working times and can report any issues.
        </CardDescription>
      </CardHeader>
      <CardContent>
        <TabsContent value="weekly">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Start Time</TableHead>
                <TableHead class="hidden sm:table-cell">
                  End Time
                </TableHead>
                <TableHead class="hidden sm:table-cell">
                  Overtime
                </TableHead>
                <TableHead class="hidden md:table-cell">
                  Working Time
                </TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              <TableRow class="hover:bg-accent">
                <TableCell>
                  2024-10-14 08:30:00
                </TableCell>
                <TableCell class="hidden sm:table-cell">
                  2024-10-14 12:00:00
                </TableCell>
                <TableCell class="hidden sm:table-cell">
                  00:00:00
                </TableCell>
                <TableCell class="hidden md:table-cell">
                  03:30:00
                </TableCell>
              </TableRow>

            </TableBody>
          </Table>
        </TabsContent>
      </CardContent>
    </Card>
  </Tabs>
</template>