<script setup>

import { CardDescription, CardHeader, CardTitle } from '@/components/ui/card'

const props = defineProps({
    title: {
        type: String,
        default:"Default"
    },
    titleColor:{
        type:String,
    },
    description: {
        type: String,
        default: 'Actions',
    },
});
</script>

<template>
    <CardHeader class="px-7">
        <CardTitle :class="titleColor">{{ title }}</CardTitle>
        <CardDescription>
            {{ description }}
        </CardDescription>
    </CardHeader>
</template>
