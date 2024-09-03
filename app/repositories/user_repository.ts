import User from '#models/user'
import { inject } from '@adonisjs/core'

@inject()
export default class UsersRepository {
  async createUser(user: any) {
    return User.create(user)
  }

  async findAll() {
    return User.all()
  }

  async findByCpf(cpf: string) {
    return User.findBy('cpf', cpf)
  }
}
