<script setup>
import { useRouter } from 'vue-router';

const props = defineProps({
  href: { type: String, required: true },
  label: { type: String, required: true },
  isActive: { type: Boolean, default: false },
  textClass: { type: String, default: 'text-muted-foreground' },
  useDropdown: { type: Boolean, default: false }, // Indicateur pour savoir si c'est un dropdown
});
const emit = defineEmits(['item-click']);
const router = useRouter();

const handleClick = () => {
  emit('item-click', props.href);
  router.push(props.href);
};


</script>

<template>
  <!-- Si l'item utilise un dropdown, on n'applique pas la navigation directe -->
  <div v-if="useDropdown" class="flex text-lg items-center gap-3 rounded-lg px-3 py-2 transition-all" :class="[
    textClass,
    { 'bg-muted text-muted-foreground': isActive },
    { 'hover:text-primary': !isActive }
  ]">
    <slot name="icon" />
    {{ label }}
    <slot />
  </div>

  <!-- Comportement classique pour les autres items -->
  <a v-else href="#" class="flex text-lg items-center gap-3 rounded-lg px-3 py-2 transition-all" :class="[
    textClass,
    { 'bg-muted text-muted-foreground': isActive },
    { 'hover:text-primary': !isActive }
  ]" @click.prevent="handleClick">
    <slot name="icon" />
    {{ label }}
    <slot name="badge" />
  </a>
</template>
