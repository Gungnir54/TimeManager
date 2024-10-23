<script setup>

import { CircleUser, Search } from 'lucide-vue-next'

import { DropdownMenu, DropdownMenuContent, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger } from '@/components/ui/dropdown-menu'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Sheet, SheetClose, SheetContent, SheetDescription, SheetFooter, SheetHeader, SheetTitle, SheetTrigger, } from '@/components/ui/sheet'

import Form from '@/components/Authentication/Form.vue'
import { useAuthService, useUserStore } from "@/stores/counter.js";
import { onMounted, ref } from 'vue';

const { logout } = useAuthService();
const userStore = useUserStore();
const isLoading = ref(true);
let userInfos = null

const props = defineProps({
  employee: {
    type: Object,
  }
})

onMounted(async () => {
  if (props.employee) {
    const response = await userStore.fetchUserById(props.employee.user_id)
    userInfos = response
    isLoading.value = false;
  }
});

const onLogout = () => {
  logout();
};

const formRef = ref(null);

const handleSubmit = async () => {
    if (formRef.value) {
        await formRef.value.submitForm();
        location.reload()
    }
};

</script>

<template>

  <header class="flex h-14 items-center gap-4 border-b bg-muted/40 px-4 lg:h-[60px] lg:px-6">
    <div class="w-full flex-1">
      <form>
        <div class="relative">
          <Search class="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input type="search" placeholder="Search..."
            class="w-full appearance-none bg-background pl-8 shadow-none md:w-2/3 lg:w-1/3" />
        </div>
      </form>
    </div>
    <DropdownMenu>
      <DropdownMenuTrigger as-child>
        <Button variant="secondary" size="icon" class="rounded-full">
          <CircleUser class="h-5 w-5" />
          <span class="sr-only">Toggle user menu</span>
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        <DropdownMenuLabel class="text-center text-gray-500">{{ userInfos.username }}</DropdownMenuLabel>
        <DropdownMenuLabel class="text-center text-green-400">My Account</DropdownMenuLabel>

        <DropdownMenuSeparator />

        <Sheet>
          <SheetTrigger as-child>
            <Button variant="ghost" class="w-full h-1/2 text-left">Edit Settings</Button>
          </SheetTrigger>
          <SheetContent class="bg-card">
            <SheetHeader>
              <SheetTitle class="text-gray-500">
                Make changes to your profile here.
              </SheetTitle>
              <SheetDescription class="mb-4">
                Click save when you're done.
              </SheetDescription>
            </SheetHeader>
            <Form v-if="userInfos" ref="formRef" submitLabel="Save" formType="modify" :userInfos="userInfos" />
            <SheetFooter>
              <SheetClose as-child>
                <Button @click="handleSubmit" variant="green">
                  Save
                </Button>
              </SheetClose>
            </SheetFooter>
          </SheetContent>
        </Sheet>

        <DropdownMenuSeparator />

        <Sheet>
          <SheetTrigger>
            <Button variant="ghost" class="w-full hover:bg-red-600 h-1/2 text-left">Delete Account</Button>
          </SheetTrigger>
          <SheetContent>
            <SheetHeader>
              <SheetTitle>Are you absolutely sure?</SheetTitle>
              <SheetDescription>
                This will permanently delete your account and remove your data from our servers.
              </SheetDescription>
            </SheetHeader>
            <SheetFooter>
              <SheetClose as-child>
                <Button variant="ghost" class="w-full hover:bg-red-600 text-left">Confirm</Button>
              </SheetClose>
            </SheetFooter>
          </SheetContent>
        </Sheet>

        <DropdownMenuSeparator />

        <Button variant="ghost" class="w-full h-1/2 text-left" @click="onLogout">Logout</Button>
      </DropdownMenuContent>
    </DropdownMenu>
  </header>

</template>