<script setup>

import Form from '@/components/Authentication/Form.vue'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'

import { useUserStore } from '@/stores/counter.js'
import { onMounted, ref } from 'vue';
import { Button } from '@/components/ui/button';
import { useRouter } from 'vue-router';

const userStore = useUserStore()
const employee = ref(null)
const router = useRouter();
onMounted(async () => {
  const storedToken = localStorage.getItem('token');

  if (storedToken) {
    employee.value = await userStore.tokenDecode(storedToken)
  } else {
    console.error("Aucun token trouvé.");
  }
});

const formCreateMemberRef = ref(null);
const formCreateTeamRef = ref(null);

const handleSubmitCreateMember = async () => {
  if (formCreateMemberRef.value) {
    await formCreateMemberRef.value.submitForm();
    router.push('/members')
  }
};

const handleSubmitCreateTeam = async () => {
  if (formCreateTeamRef.value) {
    await formCreateTeamRef.value.submitForm();
    router.push('/members')
  }
};

</script>

<template>
  <div class="grid gap-4 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-2 xl:grid-cols-2">
    <Card>
      <CardHeader>
        <CardTitle>Create new member</CardTitle>
        <CardDescription>
          You can create an account to your new employee.
        </CardDescription>
      </CardHeader>
      <CardContent>
        <Form ref="formCreateMemberRef" formType="create" submitLabel="Create" />
        <Button @click="handleSubmitCreateMember" variant="green">
          Create
        </Button>
      </CardContent>
    </Card>
    <Card>
      <CardHeader>
        <CardTitle>Create new team</CardTitle>
        <CardDescription>
          You can create a new team for your employees.
        </CardDescription>
      </CardHeader>
      <CardContent>
        <Form ref="formCreateTeamRef" formType="team" submitLabel="Create a team" />
        <Button @click="handleSubmitCreateTeam" variant="green">
          Create a team
        </Button>
      </CardContent>
    </Card>
  </div>
</template>