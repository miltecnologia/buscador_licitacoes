require 'test_helper'

class LicitacaosControllerTest < ActionController::TestCase
  setup do
    @licitacao = licitacaos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:licitacaos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create licitacao" do
    assert_difference('Licitacao.count') do
      post :create, licitacao: { codigo: @licitacao.codigo, data_abertura: @licitacao.data_abertura, link: @licitacao.link, municipio: @licitacao.municipio, objeto: @licitacao.objeto }
    end

    assert_redirected_to licitacao_path(assigns(:licitacao))
  end

  test "should show licitacao" do
    get :show, id: @licitacao
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @licitacao
    assert_response :success
  end

  test "should update licitacao" do
    put :update, id: @licitacao, licitacao: { codigo: @licitacao.codigo, data_abertura: @licitacao.data_abertura, link: @licitacao.link, municipio: @licitacao.municipio, objeto: @licitacao.objeto }
    assert_redirected_to licitacao_path(assigns(:licitacao))
  end

  test "should destroy licitacao" do
    assert_difference('Licitacao.count', -1) do
      delete :destroy, id: @licitacao
    end

    assert_redirected_to licitacaos_path
  end
end
