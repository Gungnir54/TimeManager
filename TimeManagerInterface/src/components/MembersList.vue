<script setup>

import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { Card } from '@/components/ui/card'
import DropdownGeneric from './DropdownGeneric.vue'
import HeaderTable from './HeaderTable.vue'

const props = defineProps({
    title: {
        type: String,
        default: "Default"
    },
    titleColor: {
        type: String,
    },
    description: {
        type: String,
        default: 'Manage your team.',
    },
    items: {
        type: Array,
        required: true,
    },
    headers: {
        type: Array,
        required: true,
    },
    dropdownActions: {
        type: Array,
        default: () => [],
    },
    isTeam: {
        type: Boolean,
        default: true
    },
    teamID: {
        type: Number,
    },
});


</script>

<template v-if="items">
    <Card class="sm:col-span-2">
        <HeaderTable v-if="isTeam" :title="title" :titleColor="titleColor" :description="description" />

        <Table>
            <TableHeader>
                <TableRow>
                    <TableHead v-for="(header, index) in headers" :key="index" class="text-green-400">
                        {{ header }}
                    </TableHead>
                </TableRow>
            </TableHeader>
            <TableBody>
                <TableRow class="hover:bg-slate-100/30" v-for="(item, index) in items" :key="index">
                    <TableCell>{{ item.username }}</TableCell>
                    <TableCell>{{ item.email }}</TableCell>
                    <TableCell>{{ item.role }}</TableCell>
                    <TableCell>
                        <DropdownGeneric :teamID="props.teamID" :actions="props.dropdownActions" :employee="item" />
                    </TableCell>
                </TableRow>
            </TableBody>
        </Table>
    </Card>
</template>