import { defineStore } from "pinia";
import apiClient from "@/axios";
import { useRouter } from "vue-router";
import { jwtDecode } from "jwt-decode";

export const useUserStore = defineStore("userStore", {
  state: () => ({
    isLoading: false,
    error: null,
    employees: [],
  }),

  actions: {
    async fetchUsers() {
      this.isLoading = true;
      try {
        const response = await apiClient.get("/users");

        this.employees = response.data.data.map((user) => ({
          user_id: user.id,
          username: user.username,
          email: user.email,
          role: user.role ? user.role.rolename : "employee",
        }));

        return this.employees;
      } catch (error) {
        this.error = "Erreur lors de la récupération des utilisateurs";
      } finally {
        this.isLoading = false;
      }
    },

    async fetchUserById(user_id) {
      this.isLoading = true;
      try {
        const response = await apiClient.get(`/users/${user_id}`);

        const user = {
          user_id: response.data.data.id,
          username: response.data.data.username,
          email: response.data.data.email,
          role: response.data.data.role
            ? response.data.data.role.rolename
            : "employee",
          teams: response.data.data.teams ? response.data.data.teams : [],
          workingTimes: response.data.data.workingtimes
            ? response.data.data.workingtimes
            : [],
        };

        return user;
      } catch (error) {
        this.error = "Erreur lors de la récupération de l'utilisateur";
      } finally {
        this.isLoading = false;
      }
    },

    async createUser(newUser) {
      this.isLoading = true;
      try {
        const response = await apiClient.post("/users", newUser);
        console.log(response);
      } catch (error) {
        this.error =
          error.response?.data?.message ||
          "Erreur lors de l'ajout de l'utilisateur";
      } finally {
        this.isLoading = false;
      }
    },

    async promote(user) {
      this.isLoading = true;
      if (user.role == "manager" || user.role == "general_manager") {
        console.log("Erreur, l'utilisateur ne peut pas être promu");
      } else {
        const newUser = {
          user: {
            role_id: 2,
          },
        };

        try {
          await apiClient.put(`/users/${user.user_id}`, newUser);
          let index = this.employees.findIndex((emp) => {
            return emp.user_id == user.user_id;
          });

          if (index !== -1) {
            this.employees[index].role = "manager";
            return this.employees;
          } else {
            console.log("Utilisateur non trouvé");
          }
        } catch (error) {
          this.error = "Erreur lors de la récupération de l'utilisateur";
        } finally {
          if (!this.error) {
            console.log("Tentative de promotion réussie");
          } else {
            console.log("Tentative de promotion échouée");
          }
          this.isLoading = false;
        }
      }
    },

    async demote(user) {
      this.isLoading = true;
      if (user.role == "employee" || user.role == "general_manager") {
        console.log("Erreur, l'utilisateur ne peut pas être rétrogradé");
      } else {
        const newUser = {
          user: {
            role_id: 1,
          },
        };

        try {
          await apiClient.put(`/users/${user.user_id}`, newUser);
          let index = this.employees.findIndex((emp) => {
            return emp.user_id == user.user_id;
          });

          if (index !== -1) {
            this.employees[index].role = "employee";
            return this.employees;
          } else {
            console.log("Utilisateur non trouvé");
          }
        } catch (error) {
          this.error = "Erreur lors de la récupération de l'utilisateur";
        } finally {
          if (!this.error) {
            console.log("Rétrogradation réussie");
          } else {
            console.log("Rétrogradation échouée");
          }
          this.isLoading = false;
        }
      }
    },

    async delete(user) {
      this.isLoading = true;
      try {
        await apiClient.delete(`/users/${user.user_id}`);
        let index = this.employees.findIndex((emp) => {
          return emp.user_id == user.user_id;
        });

        if (index !== -1) {
          this.employees.splice(index, 1);
          console.log("Utilisateur supprimé du store");
        } else {
          console.log("Utilisateur non trouvé dans le store");
        }
      } catch (error) {
        this.error = "Erreur lors de la suppression de l'utilisateur";
      } finally {
        if (!this.error) {
          console.log("Tentative réussie");
        } else {
          console.log("Tentative échouée");
        }
        this.isLoading = false;
      }
    },

    async update(user, newUser) {
      this.isLoading = true;
      const payload = {
        user: {
          username: newUser.username,
          email: newUser.email,
          role_id: newUser.role_id ? newUser.role_id : user.role_id,
        },
      };
      try {
        await apiClient.put(`/users/${user.user_id}`, payload);
        let index = this.employees.findIndex((emp) => {
          return emp.user_id == user.user_id;
        });

        if (index !== -1) {
          this.employees[index].username = newUser.username;
          this.employees[index].email = newUser.email;
          return this.employees;
        } else {
          console.log("Utilisateur non trouvé");
        }
      } catch (error) {
        this.error = "Erreur lors de la récupération de l'utilisateur";
      } finally {
        if (!this.error) {
          console.log("Tentative réussie");
        } else {
          console.log("Tentative échouée");
        }
        this.isLoading = false;
      }
    },

    async tokenDecode(token) {
      this.isLoading = true;
      try {
        const decodedToken = jwtDecode(token);
        return decodedToken;
      } catch (error) {
        this.error =
          error.response?.data?.message ||
          "Erreur lors de la récupération du token";
      } finally {
        if (!this.error) {
          console.log("Tentative réussie");
        } else {
          console.log("Tentative échouée");
        }
        this.isLoading = false;
      }
    },

    async register(user) {
      this.isLoading = true;
      try {
        await apiClient.post("/register", user);
      } catch (error) {
        this.error =
          error.response?.data?.message ||
          "Erreur lors de l'inscription de l'utilisateur";
      } finally {
        if (!this.error) {
          console.log("Tentative d'inscription réussie");
        } else {
          console.log("Tentative d'inscription' échouée");
          this.isLoading = false;
        }
      }
    },

    async signin(user) {
      this.isLoading = true;
      try {
        const response = await apiClient.post("/login", user);
        const token = response.data.token;
        localStorage.setItem("token", token);

        return token;
      } catch (error) {
        this.error =
          error.response?.data?.message ||
          "Erreur lors de la connexion au compte de l'utilisateur";
      } finally {
        if (!this.error) {
          console.log("Tentative de connexion réussie");
        } else {
          console.log("Tentative de connexion échouée");
          this.isLoading = false;
        }
      }
    },
  },
});

export const useAuthService = () => {
  const router = useRouter();

  const logout = () => {
    localStorage.removeItem("token");
    router.push({ name: "auth" });
  };

  return { logout };
};

export const useTeamStore = defineStore("teamStore", {
  state: () => ({
    isLoading: false,
    error: null,
    teams: [],
  }),

  actions: {
    async fetchTeams() {
      this.isLoading = true;
      try {
        const response = await apiClient.get("/teams");

        this.teams = response.data.data.map((team) => ({
          id: team.id,
          name: team.name,
          users: team.users.map((user) => ({
            user_id: user.id,
            role: user.role ? user.role.rolename : "employee",
            username: user.username,
            email: user.email,
          })),
        }));

        return this.teams;
      } catch (error) {
        this.error = "Erreur lors de la récupération des utilisateurs";
      } finally {
        this.isLoading = false;
      }
    },

    async fetchTeamById(team_id) {
      this.isLoading = true;
      try {
        const response = await apiClient.get(`/teams/${team_id}`);

        const users = response.data.data.users || [];

        const normalizedUsers = users.map((user) => ({
          user_id: user.id,
          role: user.role ? user.role.rolename : "employee",
          username: user.username,
          email: user.email,
        }));

        const team = {
          id: response.data.data.id,
          name: response.data.data.name,
          users: normalizedUsers,
        };

        return team;
      } catch (error) {
        this.error = "Erreur lors de la récupération de l'utilisateur";
      } finally {
        this.isLoading = false;
      }
    },

    async createTeam(newTeam) {
      this.isLoading = true;
      try {
        const response = await apiClient.post("/teams", newTeam);
        console.log(response);
      } catch (error) {
        this.error =
          error.response?.data?.message ||
          "Erreur lors de l'ajout de l'utilisateur";
      } finally {
        this.isLoading = false;
      }
    },

    async addToTeam(team_id, user_id) {
      this.isLoading = true;
      try {
        const response = await apiClient.post(
          `/teams/${team_id}/add_user/${user_id}`
        );
        console.log(response);
        location.reload();
      } catch (error) {
        this.error = "Erreur lors de la récupération de l'utilisateur";
      } finally {
        this.isLoading = false;
      }
    },

    async remove(team_id, user_id) {
      this.isLoading = true;
      try {
        const response = await apiClient.delete(
          `/teams/${team_id}/remove_users/${user_id}`
        );
        console.log(response);
        location.reload();
      } catch (error) {
        this.error = "Erreur lors de la récupération de l'utilisateur";
      } finally {
        this.isLoading = false;
      }
    },
  },
});

export const useDropdownStore = defineStore("dropdown", {
  state: () => ({
    teamDropdownActions: [],
    memberDropdownActions: [],
    GMDropdownActions: [],
  }),

  actions: {
    setDropdownActions() {
      this.teamDropdownActions = [
        { label: "Dashboard", handler: () => this.navigateToDashboard() },
        {
          label: "Remove",
          handler: (teamMember) => this.removeItem(teamMember),
        },
        {
          label: "Delete",
          handler: (teamMember) => this.deleteItem(teamMember),
        },
      ];

      this.GMDropdownActions = [
        { label: "Dashboard", handler: () => this.navigateToDashboard() },
        { label: "Promote", handler: (teamMember) => this.promote(teamMember) },
        { label: "Demote", handler: (teamMember) => this.demote(teamMember) },
        {
          label: "Delete",
          handler: (teamMember) => this.delete(teamMember),
        },
      ];

      this.memberDropdownActions = [
        { label: "Add", handler: (employee) => this.addToTeam(employee) },
      ];
    },
  },
});
