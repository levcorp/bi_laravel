<?php

namespace App\Http\Controllers\JWT;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Auth;
use Validator;
use App\User;
use JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;

class AuthController extends Controller
{
    
    public function register(Request $request)
    {
        $v = Validator::make($request->all(), [
            'name' => 'required|min:3',
            'email' => 'required|email|unique:users',
            'password'  => 'required|min:3|confirmed',
        ]);
        if ($v->fails())
        {
            return response()->json([
                'status' => 'error',
                'errors' => $v->errors()
            ], 422);
        }
        $user = new User();
        $user->name = $request->name;
        $user->email = $request->email;
        $user->password = bcrypt($request->password);
        $user->save();
        return response()->json(['status' => 'success'], 200);
    }
    /**
     * Login user and return a token
     */
    public function login(Request $request)
    {
        $credentials = $request->only('email', 'password');

        try {
            if (! $token = JWTAuth::attempt($credentials)) {
                return response()->json(['error' => 'invalid_credentials'], 400);
            }
        } catch (JWTException $e) {
            return response()->json(['error' => 'could_not_create_token'], 500);
        }

        return response()->json(compact('token'))->header('Authorization', $token);
    }
    /**
     * Logout User
     */
    public function logout()
    {
        $this->guard()->logout();
        return response()->json([
            'status' => 'success',
            'msg' => 'Logged out Successfully.'
        ], 200);
    }
    /**
     * Get authenticated user
     */
    public function user(Request $request)
    {
        try {

            if (! $user = JWTAuth::parseToken()->authenticate()) {
                    return response()->json(['user_not_found'], 404);
            }

            } catch (Tymon\JWTAuth\Exceptions\TokenExpiredException $e) {

                    return response()->json(['token_expired'], $e->getStatusCode());

            } catch (Tymon\JWTAuth\Exceptions\TokenInvalidException $e) {

                    return response()->json(['token_invalid'], $e->getStatusCode());

            } catch (Tymon\JWTAuth\Exceptions\JWTException $e) {

                    return response()->json(['token_absent'], $e->getStatusCode());

            }

            return response()->json(compact('user'));
    }
    /**
     * Refresh JWT token
     */
    public function refresh()
    {
        if ($token = $this->guard()->refresh()) {
            return response()
                ->json(['status' => 'successs'], 200)
                ->header('Authorization', $token);
        }
        return response()->json(['error' => 'refresh_token_error'], 401);
    }
    /**
     * Return auth guard
     */
    private function guard()
    {
        return Auth::guard();
    }

}
