<script setup>
import { Input } from '@/components/ui/input';
import { defineProps } from 'vue';

const props = defineProps({
  label: {
    type: String,
    required: true,
  },
  id: {
    type: String,
    required: true,
  },
  type: {
    type: String,
    default: 'text',
  },
  modelValue: {
    type: [String, Number],
    required: true,
  },
  placeholder: {
    type: String,
    default: '',
  },
  error: {
    type: String,
    default: '',
  },
});
</script>

<template>
  <div class="mb-4">
    <label :for="props.id" class="block mb-1 text-sm font-medium">{{ props.label }}</label>
    <Input
      :type="props.type"
      :id="props.id"
      :placeholder="props.placeholder"
      :value="props.modelValue"
      @input="$emit('update:modelValue', $event.target.value)"
    />
    <span v-if="props.error" class="text-red-500 text-sm">{{ props.error }}</span>
  </div>
</template>
