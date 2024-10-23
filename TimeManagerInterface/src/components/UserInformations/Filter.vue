<script setup>

import { Button } from '@/components/ui/button'
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger } from '@/components/ui/dropdown-menu'
import { Checkbox } from '@/components/ui/checkbox'
import { File, ListFilter } from 'lucide-vue-next'

</script>

<template>

    <div class="ml-auto flex items-center gap-2">
        <DropdownMenu>
            <DropdownMenuTrigger as-child>
            <Button variant="outline" size="sm" class="h-7 gap-1 rounded-md px-3">
                <ListFilter class="h-3.5 w-3.5" />
                <span class="sr-only sm:not-sr-only">Filter</span>
            </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
            <DropdownMenuLabel>Filter by</DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem>
                <div class="items-top flex space-x-2">
                <Checkbox id="terms1" />
                <label
                    for="terms2"
                    class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                >
                    Fulfilled
                </label>
                </div>
            </DropdownMenuItem>
            <DropdownMenuItem>
                <div class="items-top flex space-x-2">
                <Checkbox id="terms1" />
                <label
                    for="terms2"
                    class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                >
                    Declined
                </label>
                </div>
            </DropdownMenuItem>
            <DropdownMenuItem>
                <div class="items-top flex space-x-2">
                <Checkbox id="terms1" />
                <label
                    for="terms2"
                    class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                >
                    Refunded
                </label>
                </div>
            </DropdownMenuItem>
            </DropdownMenuContent>
        </DropdownMenu>
        <Button variant="outline" size="sm" class="h-7 gap-1 rounded-md px-3">
            <File class="h-3.5 w-3.5" />
            <span class="sr-only sm:not-sr-only">Export</span>
        </Button>
        </div>

</template>