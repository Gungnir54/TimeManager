import { createRouter, createWebHistory } from "vue-router";
import Layout from "@/views/Layout.vue"; // Le layout général
import Dashboard from "../views/Dashboard.vue";
import Auth from "@/components/Authentication/Auth.vue";
import Create from "@/views/Create.vue";
import Members from "@/views/Members.vue";
import ManageTeams from "@/views/ManageTeams.vue";
import ChartManager from "@/components/ChartManager.vue";
import ClockManager from "@/components/ClockManager.vue";
import MyTeam from "@/views/MyTeam.vue";

function isAuthenticated() {
  return !!localStorage.getItem("token");
}

const routes = [
  {
    path: "/auth",
    name: "auth",
    component: Auth,
  },
  {
    path: "/",
    redirect: "/dashboard",
  },
  {
    path: "/:pathMatch(.*)*",
    redirect: "/dashboard",
  },
  {
    path: "/",
    component: Layout,
    children: [
      {
        path: "/dashboard/:id?",
        name: "home",
        component: Dashboard,
        meta: { requiresAuth: true },
      },
      {
        path: "/create",
        name: "create",
        component: Create,
        meta: { requiresAuth: true },
      },
      {
        path: "/members",
        name: "members",
        component: Members,
        meta: { requiresAuth: true },
      },
      {
        path: "/manage-teams",
        name: "manageTeams",
        component: ManageTeams,
        meta: { requiresAuth: true },
      },
      {
        path: "/chart-manager",
        name: "chartManager",
        component: ChartManager,
        meta: { requiresAuth: true },
      },
      {
        path: "/clock-manager",
        name: "clockManager",
        component: ClockManager,
        meta: { requiresAuth: true },
      },
      {
        path: "/myteam/:id?",
        name: "myTeam",
        component: MyTeam,
        props: true,
        meta: { requiresAuth: true },
      },
    ],
  },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

router.beforeEach((to, from, next) => {
  if (to.meta.requiresAuth && !isAuthenticated()) {
    // Si la route nécessite une authentification et que l'utilisateur n'est pas authentifié
    next({ name: "auth" }); // Redirige vers la page de connexion
  } else {
    next();
  }
});

export default router;
