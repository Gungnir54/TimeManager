<script>
export default {
  data() {
    return {
      userId: null,
      workingTimeId: null,
    };
  },
};
</script>

<template>
  <div id="app" class="flex flex-col items-center">
    <router-view/>
  </div>
</template>
