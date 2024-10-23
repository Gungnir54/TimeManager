<script setup>
import { cn } from "@/lib/utils";

const props = defineProps({
  class: { type: null, required: false },
});
</script>

<template>
  <tr
    :class="
      cn(
        'border-b transition-colors data-[state=selected]:bg-slate-100 dark:hover:bg-slate-800/50 dark:data-[state=selected]:bg-slate-800',
        props.class,
      )
    "
  >
    <slot />
  </tr>
</template>
