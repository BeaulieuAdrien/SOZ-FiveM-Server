import axios from 'axios';

import { On, Once, OnEvent } from '../../core/decorators/event';
import { Exportable } from '../../core/decorators/exports';
import { Inject } from '../../core/decorators/injectable';
import { Provider } from '../../core/decorators/provider';
import { Rpc } from '../../core/decorators/rpc';
import { Permissions } from '../../core/permissions';
import { ServerEvent } from '../../shared/event';
import { PlayerClientState, PlayerServerState } from '../../shared/player';
import { RpcServerEvent } from '../../shared/rpc';
import { QBCore } from '../qbcore';
import { ServerStateService } from '../server.state.service';
import { PlayerStateService } from './player.state.service';

@Provider()
export class PlayerProvider {
    @Inject(QBCore)
    private QBCore: QBCore;

    @Inject(Permissions)
    private permissions: Permissions;

    @Inject(PlayerStateService)
    private playerStateService: PlayerStateService;

    @Inject(ServerStateService)
    private serverStateService: ServerStateService;

    private jwtTokenCache: Record<string, string> = {};

    @On('QBCore:Server:PlayerLoaded', false)
    onPlayerLoaded(player: any) {
        // This is an event from qb when player is fully loaded but screen is not faded out so we dont' trigger client event
        this.permissions.addPlayerRole(player.PlayerData.source, player.PlayerData.role);
        this.serverStateService.addPlayer(player.PlayerData);
    }

    @On('QBCore:Server:PlayerUpdate', false)
    onPlayerUpdate(player: any) {
        this.serverStateService.updatePlayer(player);
    }

    @On('QBCore:Server:PlayerUnload', false)
    onPlayerUnload(source: number) {
        this.serverStateService.removePlayer(source);
    }

    @Once()
    onStart() {
        const connectedSources = this.QBCore.getPlayersSources();

        for (const source of connectedSources) {
            const player = this.QBCore.getPlayer(source);

            this.serverStateService.addPlayer(player.PlayerData);
            this.permissions.addPlayerRole(source, player.PlayerData.role);

            // Trigger client event to existing clieant (only useful for dev)
            TriggerClientEvent('QBCore:Client:OnPlayerLoaded', player.PlayerData.source);
        }
    }

    @Rpc(RpcServerEvent.PLAYER_GET_SERVER_STATE)
    public getServerState(source: number): PlayerServerState {
        return this.playerStateService.getServerState(source);
    }

    @Rpc(RpcServerEvent.PLAYER_GET_CLIENT_STATE)
    public getClientState(source: number, target: number | null): PlayerClientState {
        return this.playerStateService.getClientState(target === null ? source : target);
    }

    @Exportable('GetPlayerState')
    public getState(source: number): PlayerClientState {
        return this.playerStateService.getClientState(source);
    }

    @Exportable('SetPlayerState')
    @OnEvent(ServerEvent.PLAYER_UPDATE_STATE)
    public setPlayerClientState(source: number, stateUpdate: Partial<PlayerClientState>): PlayerClientState {
        return this.playerStateService.setClientState(source, stateUpdate);
    }

    @Rpc(RpcServerEvent.PLAYER_GET_JWT_TOKEN)
    public async getJwtToken(source: number): Promise<string | null> {
        const steam = this.playerStateService.getIdentifier(source.toString());

        if (this.jwtTokenCache[steam]) {
            return this.jwtTokenCache[steam];
        }

        const url = GetConvar('soz_api_endpoint', 'https://api.soz.zerator.com') + '/accounts/create-token/' + steam;

        const response = await axios.get(url, {
            auth: {
                username: GetConvar('soz_api_username', 'admin'),
                password: GetConvar('soz_api_password', 'admin'),
            },
            validateStatus: () => true,
        });

        if (response.status === 200) {
            this.jwtTokenCache[steam] = response.data.token;
            return response.data.toString();
        }

        return null;
    }
}
