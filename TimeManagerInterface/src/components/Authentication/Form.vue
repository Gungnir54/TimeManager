<script setup>
import { reactive, ref } from 'vue';
import { useRouter } from 'vue-router';
import * as yup from 'yup';
import FormField from './FormField.vue';

import { Select, SelectContent, SelectGroup, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'

import { useUserStore, useTeamStore } from '@/stores/counter.js';
import { onMounted } from 'vue';


const router = useRouter();
const teamStore = useTeamStore();
const userStore = useUserStore();
const employees = ref([]);
const isLoading = ref(true);

onMounted(async () => {
  try {
    const response = await userStore.fetchUsers();
    employees.value = response
  } catch (error) {
    console.error("Erreur lors de la récupération des utilisateurs", error);
  } finally {
    isLoading.value = false
  }
});


const props = defineProps({
  formType: {
    type: String,
    required: true,
  },
  submitLabel: {
    type: String,
    default: 'Submit',
  },
  userInfos: {
    type: Object,
  }
});

const formData = reactive({
  username: '',
  name: '',
  users:[],
  email: '',
  password: '',
  confirmPassword: '',
  role: '',
  leader: '',
});

const errors = reactive({
  username: '',
  name: '',
  users:[],
  email: '',
  password: '',
  confirmPassword: '',
  role: '',
  leader: '',
});

const schemaSignin = yup.object({
  email: yup.string().email('Must be a valid email'),
  password: yup.string().required('Password is required').min(6, 'Password must be at least 6 characters'),
});

const schemaModify = yup.object({
  username: yup.string().min(2, 'Must be at least 2 characters').max(50, 'Must be less than 50 characters'),
  email: yup.string().email('Must be a valid email'),
});

const schemaTeam = yup.object({
  name: yup.string().required('Name is required').min(2, 'Must be at least 2 characters').max(50, 'Must be less than 50 characters'),
  leader: yup.string().required('You must choose a leader')
});

const schemaCreate = yup.object({
  username: yup.string().required('Username is required').min(2, 'Must be at least 2 characters').max(50, 'Must be less than 50 characters'),
  email: yup.string().required('Email is required').email('Must be a valid email'),
  password: yup.string().required('Password is required').min(6, 'Password must be at least 6 characters'),
  role: yup.string().required('You must choose a role')
});

const schemaSignup = yup.object({
  username: yup.string().required('Username is required').min(2, 'Must be at least 2 characters').max(50, 'Must be less than 50 characters'),
  email: yup.string().required('Email is required').email('Must be a valid email'),
  password: yup.string().required('Password is required').min(6, 'Password must be at least 6 characters'),
  confirmPassword: yup.string().oneOf([yup.ref('password')], 'Passwords must match').required('Please confirm your password'),
});

const validateForm = async () => {
  try {
    let schema
    switch (props.formType) {
      case 'signin':
        schema = schemaSignin
        break
      case 'register':
        schema = schemaSignup
        break
      case 'modify':
        schema = schemaModify
        break
      case 'team':
        schema = schemaTeam
        break
      default:
        schema = schemaCreate
        break
    }

    await schema.validate(formData, { abortEarly: false });
    clearErrors();
    return true;
  } catch (validationErrors) {
    clearErrors();
    validationErrors.inner.forEach((error) => {
      errors[error.path] = error.message;
    });
    return false;
  }
};

const onSubmit = async () => {
  const isValid = await validateForm();

  if (!isValid) {
    return;
  }

  switch (props.submitLabel) {

    case 'Create': {
      const newUser = {
        username: formData.username,
        email: formData.email,
        password: formData.password,
        role_id: formData.role == "manager" ? 2 : 1
      };
      
      await userStore.createUser(newUser);
      resetForm();
      break;

    }

    case 'Register': {
      const newUser = {
        username: formData.username,
        email: formData.email,
        password: formData.password,
        role: formData.role || 1
      };
      await userStore.register(newUser);
      resetForm();
      break;

    }

    case 'Create a team': {
      const selectedLeader = employees.value.find(emp => emp.username === formData.leader)
      const newTeam = {
        team: {
          name: formData.name,
          users: [selectedLeader.user_id]
        }
      };
      await teamStore.createTeam(newTeam);
      location.reload()
      resetForm();
      break;
    }
    
    case 'Save': {
      const user = props.userInfos
      
      const newUser = {
        username: formData.username,
        email: formData.email,
      };
      await userStore.update(user, newUser);
      resetForm();

      break;
    }

    case 'Sign In': {
      const user = {
        email: formData.email,
        password: formData.password,
      };
      const token = await userStore.signin(user);

      if (token) {
        router.push('/dashboard');
      }
      break;
    }

    default:
      console.error('Action non supportée pour ce label.');
      break;
  }
};


const clearErrors = () => {
  Object.keys(errors).forEach(key => {
    errors[key] = '';
  });
};

const resetForm = () => {
  formData.username = '';
  formData.email = '';
  formData.password = '';
  formData.confirmPassword = '';
};

defineExpose({
  submitForm: onSubmit,
});

const showField = (field) => {
  const fieldsForSignin = ['email', 'password'];
  const fieldsForSignup = ['username', 'email', 'password', 'confirmPassword'];
  const fieldsForCreate = ['username', 'email', 'password', 'role'];
  const fieldsForModify = ['username', 'email'];
  const fieldsForTeam = ['name', 'leader'];

  switch (props.formType) {
    case 'signin':
      return fieldsForSignin.includes(field);
    case 'register':
      return fieldsForSignup.includes(field);
    case 'modify':
      return fieldsForModify.includes(field);
    case 'team':
      return fieldsForTeam.includes(field);
    default:
      return fieldsForCreate.includes(field);
  }
}
</script>

<template>
  <form @submit.prevent="onSubmit">
    <FormField v-if="showField('username')" label="Username" id="username" v-model="formData.username"
      :error="errors.username" placeholder="Enter username" />

    <FormField v-if="showField('name')" label="Name" id="name" v-model="formData.name" :error="errors.name"
      placeholder="Enter name" />

    <FormField v-if="showField('email')" label="Email" id="email" type="email" v-model="formData.email"
      :error="errors.email" placeholder="Enter email" />

    <FormField v-if="showField('password')" label="Password" id="password" type="password" v-model="formData.password"
      :error="errors.password" />

    <FormField v-if="showField('confirmPassword')" label="Confirm Password" id="confirmPassword" type="password"
      v-model="formData.confirmPassword" :error="errors.confirmPassword" />

    <div v-if="showField('role')" label="Role" id="role" :error="errors.role" class="mb-4">
      <Select v-model="formData.role">
        <SelectTrigger class="bg-background w-[180px]">
          <SelectValue placeholder="Select a role" />
        </SelectTrigger>
        <SelectContent class="bg-card">
          <SelectGroup>
            <SelectItem class="focus:bg-accent text-accent-foreground focus:text-accent-foreground" value="employee">
              Employee
            </SelectItem>
            <SelectItem class="focus:bg-accent text-accent-foreground focus:text-accent-foreground" value="manager">
              Manager
            </SelectItem>
          </SelectGroup>
        </SelectContent>
      </Select>
      <span v-if="errors.role" class="text-red-500 text-sm">{{ errors.role }}</span>
    </div>

    <div v-if="showField('leader')" label="Leader" id="leader" :error="errors.leader" class="mb-4">
      <Select v-model="formData.leader">
        <SelectTrigger class="bg-background w-[180px]">
          <SelectValue placeholder="Select a team leader" />
        </SelectTrigger>
        <SelectContent class="bg-card">
          <SelectGroup>
            <SelectItem v-for="employee in employees" :key="employee.username" :value="employee.username"
              class="focus:bg-accent text-accent-foreground focus:text-accent-foreground">
              {{ employee.username }}
            </SelectItem>
          </SelectGroup>
        </SelectContent>
      </Select>
      <span v-if="errors.leader" class="text-red-500 text-sm">{{ errors.leader }}</span>
    </div>
  </form>
</template>