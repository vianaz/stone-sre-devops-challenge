import UsersService from '#services/user_service'
import { createUserValidator } from '#validators/user'
import { inject } from '@adonisjs/core'
import type { HttpContext } from '@adonisjs/core/http'
import { Get, Post } from '@softwarecitadel/girouette'

@inject()
export default class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('/users')
  async index() {
    return this.usersService.getUsers()
  }

  @Post('/users')
  async store({ request, response }: HttpContext) {
    const payload = await request.validateUsing(createUserValidator)
    const user = await this.usersService.createUser(payload)
    return response.status(201).json(user)
  }

  @Get('/users/:cpf')
  async showByCpf({ params, response }: HttpContext) {
    const user = await this.usersService.getUserByCpf(params.cpf)

    if (!user) return response.status(404).json({ message: 'User not found' })
    return user
  }
}
