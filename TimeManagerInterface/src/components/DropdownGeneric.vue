<script setup>
import { MoreHorizontal } from 'lucide-vue-next'
import { DropdownMenu, DropdownMenuContent, DropdownMenuLabel, DropdownMenuTrigger } from '@/components/ui/dropdown-menu'
import { Button } from '@/components/ui/button'

import { useDropdownStore, useTeamStore, useUserStore } from '@/stores/counter.js'

import { useRouter } from 'vue-router';

const teamStore = useTeamStore()
const userStore = useUserStore()
const router = useRouter();

const props = defineProps({
    actions: {
        type: Array,
        required: true,
    },
    label: {
        type: String,
        default: 'Actions',
    },
    employee: {
        type: Object,
        required: true,
    },
    teamID: {
        type: Number,
    }
});

const handleAction = async (action) => {
    switch (action.label) {
        case 'Remove':
            await teamStore.remove(props.teamID, props.employee.user_id);
            break;
        case 'Delete':
            await userStore.delete(props.employee);
            break;
        case 'Add':
            await teamStore.addToTeam(props.teamID, props.employee.user_id);
            break;
        case 'Promote':
            await userStore.promote(props.employee);
            break;
        case 'Demote':
            await userStore.demote(props.employee);
            break;
        case 'Dashboard':
            router.push(`/dashboard/${props.employee.user_id}`)
            break;
        default:
            console.log('Unknown action');
    }
};

</script>

<template>
    <DropdownMenu>
        <DropdownMenuTrigger as-child>
            <MoreHorizontal class="h-5 w-5 mt-1 cursor-pointer hover:text-green-400" />
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end">
            <DropdownMenuLabel class="text-center text-green-400">{{ label }}</DropdownMenuLabel>
            <div v-for="(action, index) in actions" :key="index">
                <Button variant="ghost" class="w-full"
                    :class="{ 'hover:bg-red-600': action.label === 'Delete', 'hover:bg-green-400': action.label === 'Promote' }"
                    @click="handleAction(action)">
                    {{ action.label }}
                </Button>
            </div>
        </DropdownMenuContent>
    </DropdownMenu>
</template>
