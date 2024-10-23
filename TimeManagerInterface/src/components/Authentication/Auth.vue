<script setup>

import { Card, CardTitle } from '@/components/ui/card'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { Button } from '@/components/ui/button';
import Form from './Form.vue'
import { ref } from 'vue';

const formRef = ref(null);

const handleSubmit = async () => {
    if (formRef.value) {
        await formRef.value.submitForm();
    }
};

</script>

<template>
    <Card class="p-20 mt-10">
        <CardTitle class="text-2xl text-center mb-10">
            Welcome to the Authentication Page
        </CardTitle>
        <Tabs default-value="signin" class="w-[600px]">
            <TabsList class="grid w-full grid-cols-2">
                <TabsTrigger value="signin">
                    Sign In
                </TabsTrigger>
                <TabsTrigger value="register">
                    Register
                </TabsTrigger>
            </TabsList>
            <TabsContent value="signin">
                <Form ref="formRef" formType="signin" submitLabel="Sign In" />
                <Button @click="handleSubmit" variant="green">
                    Sign In
                </Button>
            </TabsContent>
            <TabsContent value="register">
                <Form ref="formRef" formType="register" submitLabel="Register" />
                <Button @click="handleSubmit" variant="green">
                    Register
                </Button>
            </TabsContent>
        </Tabs>
    </Card>
</template>