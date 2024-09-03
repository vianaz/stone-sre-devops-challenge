import { inject } from '@adonisjs/core'

@inject()
export default class UsersRepository {
  async createUser(user: any) {
    return user
  }

  async findAll() {
    return 'All users'
  }

  async findByCpf(cpf: string) {
    return cpf
  }
}
