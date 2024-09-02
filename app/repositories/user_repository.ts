import { inject } from "@adonisjs/core";

@inject()
export default class UsersRepository {
  async createUser() {
    return "User created";
  }

  async findAll() {
    return "All users";
  }

  async findByCpf(cpf: string) {
    return "User by cpf";
  }

}
