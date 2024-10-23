<script setup>

import { Avatar } from '@/components/ui/avatar'
import { Card } from '@/components/ui/card'
import { CircleUserRound } from 'lucide-vue-next'
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger, DialogClose } from '@/components/ui/dialog'
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger } from '@/components/ui/alert-dialog'
import Form from '@/components/Authentication/Form.vue'

import { useUserStore } from '@/stores/counter.js'
import { ref, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';

const userStore = useUserStore()
const props = defineProps({
    employee: {
        type: Object,
        required: true,
    }
})

const router = useRouter();
const isLoading = ref(true);
const userInfos = ref(null);
const connectedUserRole = ref(null);
const formRef = ref(null);

const loadEmployeeData = async () => {
    if (props.employee) {
        isLoading.value = true;
        const response = await userStore.fetchUserById(props.employee.user_id);
        userInfos.value = response;
        isLoading.value = false;
    }
};

const loadConnectedUser = async () => {
    const storedToken = localStorage.getItem('token');
    if (storedToken) {
        const decodedToken = await userStore.tokenDecode(storedToken);
        const response = await userStore.fetchUserById(decodedToken.user_id)
        connectedUserRole.value = response.role
    }
};

const handleSubmit = async () => {
    if (formRef.value) {
        await formRef.value.submitForm();
        location.reload()
    }
};
const handlePromote = async (userInfos) => {
    await userStore.promote(userInfos);
    location.reload()
};
const handleDemote = async (userInfos) => {
    await userStore.demote(userInfos);
    location.reload()
};
const handleDelete = async (userInfos) => {
    await userStore.delete(userInfos);
    router.push('/members')
};
onMounted(async () => {
    await loadEmployeeData();
    await loadConnectedUser()
});


watch(
    () => props.employee,
    async (newEmployee) => {
        if (newEmployee) {
            await loadEmployeeData();
        }
    },
    { immediate: true }
);

</script>

<template>
    
    <Card class="overflow-hidden sm:col-span-2">
        <div className="flex items-center gap-6 p-6">
            <Avatar className="h-20 w-20">
                <CircleUserRound :size="48" :stroke-width="2" />
            </Avatar>
            <div v-if="!isLoading && userInfos" className="space-y-1">
                <h3 className="text-xl font-bold">{{ userInfos.username }}</h3>
                <div className="text-gray-500 dark:text-gray-400 text-sm">
                    <p>{{ userInfos.role || "employee" }}</p>
                </div>
            </div>
            <div v-else>
                <p>Loading...</p>
            </div>
        </div>
        <div v-if="!isLoading && employee"
            className="border-t border-gray-200 dark:border-gray-800 px-6 py-4 grid grid-cols-2 gap-4">
            <div>
                <div>
                    <p className="text-gray-500 dark:text-gray-400 text-sm">Email</p>
                    <p className="font-medium">{{ userInfos.email }}</p>
                </div>
            </div>
            <div>
                <div>
                    <p className="text-gray-500 dark:text-gray-400 text-sm">Arrival Time</p>
                    <p className="font-medium">YYYY-MM-DD HH:MM:SS</p>
                </div>
                <div>
                    <p className="text-gray-500 dark:text-gray-400 text-sm">Departure Time</p>
                    <p className="font-medium">YYYY-MM-DD HH:MM:SS</p>
                </div>
            </div>
        </div>
        <div v-if="connectedUserRole && connectedUserRole === 'manager'"
            className="border-t border-gray-200 dark:border-gray-800 px-6 py-4 grid grid-cols-2 gap-4">

            <div class="flex justify-center gap-10 items-center mx-auto">
                <Dialog>
                    <DialogTrigger as-child>
                        <Button variant="outline">EDIT SETTINGS</Button>
                    </DialogTrigger>
                    <DialogContent class="sm:max-w-[425px]">
                        <DialogHeader>
                            <DialogTitle>Edit employee's profil</DialogTitle>
                            <DialogDescription>
                                Make changes to your employee's profil. Click save when you're done.
                            </DialogDescription>
                        </DialogHeader>
                        <Form v-if="userInfos" ref="formRef" submitLabel="Save" formType="modify"
                            :userInfos="userInfos" />
                        <DialogFooter>
                            <DialogClose>
                                <Button @click="handleSubmit" variant="green">
                                    Save
                                </Button>
                            </DialogClose>
                        </DialogFooter>
                    </DialogContent>
                </Dialog>
                <Button @click="handlePromote(userInfos)" variant="outline"
                    class=" hover:bg-green-500/90">PROMOTE</Button>
                <Button @click="handleDemote(userInfos)" variant="outline">DEMOTE</Button>
                <AlertDialog>
                    <AlertDialogTrigger>
                        <Button variant="outline" class="hover:bg-red-600/90">DELETE</Button>
                    </AlertDialogTrigger>
                    <AlertDialogContent class="bg-card">
                        <AlertDialogHeader>
                            <AlertDialogTitle>Are you absolutely sure?</AlertDialogTitle>
                            <AlertDialogDescription>
                                This action cannot be undone. This will permanently delete this account
                                and remove datas from our servers.
                            </AlertDialogDescription>
                        </AlertDialogHeader>
                        <AlertDialogFooter>
                            <AlertDialogAction @click="handleDelete(userInfos)" class="hover:bg-red-600/90">Confirm
                            </AlertDialogAction>
                            <AlertDialogCancel>Cancel</AlertDialogCancel>
                        </AlertDialogFooter>
                    </AlertDialogContent>
                </AlertDialog>

            </div>

        </div>
    </Card>



</template>