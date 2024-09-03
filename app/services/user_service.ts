import UsersRepository from "#repositories/user_repository";
import { inject } from "@adonisjs/core";

type User = {
  name: string;
  cpf: string;
  email: string;
  birthdate: Date;
}

@inject()
export default class UsersService {
  constructor(
    private readonly usersRepository: UsersRepository
  ) {}

  async createUser(user: User) {
    return this.usersRepository.createUser(user);
  }

  async getUsers() {
    return this.usersRepository.findAll();
  }

  async getUserByCpf(cpf: string) {
    return this.usersRepository.findByCpf(cpf);
  }
}
