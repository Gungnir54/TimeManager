<script setup>

import { Progress } from '@/components/ui/progress'
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card'

</script>

<template>

    <div class="grid sm:col-span-2 gap-4 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-2 xl:grid-cols-2">
        <Card class="sm:col-span-2">
            <CardHeader>
                <CardTitle>Your Average Attendance</CardTitle>
            </CardHeader>
        </Card>
        <Card>
            <CardHeader class="pb-2">
                <CardDescription>Today</CardDescription>
                <CardTitle class="text-4xl">
                    06H 15Min
                </CardTitle>
            </CardHeader>
            <CardContent>
                <div class="text-xs text-muted-foreground">
                    01H 45Min before your daily goal
                </div>
            </CardContent>
            <CardFooter>
                <Progress :model-value="78" aria-label="78%" />
            </CardFooter>
        </Card>
        <Card>
            <CardHeader class="pb-2">
                <CardDescription>This Week</CardDescription>
                <CardTitle class="text-3xl">
                    14H 15Min
                </CardTitle>
            </CardHeader>
            <CardContent>
                <div class="text-xs text-muted-foreground">
                    25H 45Min before your weekly goal
                </div>
            </CardContent>
            <CardFooter>
                <Progress :model-value="35" aria-label="35%" />
            </CardFooter>
        </Card>
    </div>

</template>