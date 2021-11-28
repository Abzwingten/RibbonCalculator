using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Parabox.CSG;
using Parabox.STL;
using UnityEditor;
using UnityEngine;
using UnityEngine.ProBuilder;
using UnityEngine.ProBuilder.MeshOperations;
using Object = System.Object;

namespace RibbonSolver
{
    public class FormGenerator
    {
        private static Mesh _cube;
        private static MeshRenderer _meshRenderer;
        private static MeshFilter _meshFilter;
        private static ProBuilderMesh _proBuilderMesh;
        private static List<GameObject> _gameObjects;

        [MenuItem("RibbonSolver/Create Ribbon Form")]
        private static void CreateRibbonForm()
        {
            var linesCount = 17;
            var space = 0.3f;
            var baseWidth = 17.2f;
            var actionZoneWidth = baseWidth + linesCount / 2f * space -
                (baseWidth + linesCount / 2f * space) / linesCount - 0.5f * space * space * linesCount - space;
            var step = actionZoneWidth / linesCount;
            var lineWidth = actionZoneWidth / linesCount * step;
            var actionZoneHeigth = 69;
            var deadZone = 16;
            var thin = 0.05f;

            var cubeObject = GameObject.CreatePrimitive(PrimitiveType.Cube);
            _cube = cubeObject.GetComponent<MeshFilter>().sharedMesh;
            GameObject.DestroyImmediate(cubeObject);

            var ribbonGO = GameObject.Find("Ribbon");
            var ribbonProMesh = ribbonGO.GetComponent<ProBuilderMesh>();
            if (ribbonProMesh == null)
            {
                _proBuilderMesh = ribbonProMesh = ribbonGO.AddComponent<ProBuilderMesh>();
            }

            _meshFilter = ribbonGO.GetComponent<MeshFilter>();
            _meshRenderer = ribbonGO.GetComponent<MeshRenderer>();

            var list = new List<Mesh>(300);

            var S = GetS();
            var middleS = S / linesCount;
            var actualWidth = 0f;

            var widths = new List<float>();
            for (int i = 0; i < linesCount; i++)
            {
                widths.Add(step * GetRangeS((float) i / linesCount, (i + 1f) / linesCount) / middleS);
            }

            var goList = new List<GameObject>();
            var accum = 0f;
            _gameObjects = goList;
            for (int i = 0; i < linesCount; i++)
            {
                actualWidth = widths[i];
                Debug.Log(actualWidth + " Acc " + accum);

                //list.Add(AddCube(new Vector3(accum, 0, 0), new Vector3(actualWidth - space, thin, actionZoneHeigth)));
                //list.Add(AddCube(new Vector3(accum, 0, actionZoneHeigth), new Vector3(actualWidth - space, thin, accum)));


                var transformPosition = new Vector3(accum, 0, 0);
                var sizes = new Vector3(actualWidth - space, thin, actionZoneHeigth);
                var delta = (actualWidth - middleS);
                //рабочая зона
                CreateCube(transformPosition, sizes);
                //верхний выход из рабочей зоны
                CreateCube(new Vector3(accum, 0, actionZoneHeigth), new Vector3(actualWidth - space, thin, accum));

                //нижний выход из рабочей зоны
                //условие для выравнивания дорожки под пятачок
                if (i == linesCount - 1)
                {
                    CreateCube(new Vector3(accum, 0, -accum + widths[i - 1]),
                        new Vector3(actualWidth - space, thin, accum + step));
                    CreateCube(new Vector3(accum, 0, -accum + widths[i - 1]), new Vector3(5, thin, 5));
                }
                else
                    CreateCube(new Vector3(accum, 0, -accum + (widths[0] - actualWidth)),
                        new Vector3(actualWidth - space, thin, accum));

                //верхний обход мертвой зоны
                CreateCube(
                    new Vector3(-accum - deadZone - actualWidth * 2 + delta - widths[0], 0, actionZoneHeigth + accum),
                    new Vector3(2 * accum + deadZone + actualWidth * 3 - space - delta + widths[0], thin,
                        actualWidth - space));

                //обход мертвой зоны сбоку
                if (i == 0)
                {
                    CreateCube(new Vector3(-accum - deadZone - actualWidth - widths[0], 0, space),
                        new Vector3(actualWidth - space, thin, actionZoneHeigth - space));
                    CreateCube(new Vector3(-accum - deadZone - actualWidth - widths[0], 0, space),
                        new Vector3(5, thin, 5));
                }
                else
                {
                    CreateCube(new Vector3(-accum - deadZone - actualWidth - widths[0], 0, 0),
                        new Vector3(actualWidth - space, thin, actionZoneHeigth));
                }


                //нижний вход в обход мертвой зоны
                if (i > 0)
                    CreateCube(new Vector3(-accum - deadZone - actualWidth - widths[0], 0, -accum + widths[0]),
                        new Vector3(actualWidth - space, thin, accum - widths[0]));

                //нижний обход мертвой зоны
                if (i > 0)
                    CreateCube(
                        new Vector3(-accum - deadZone - widths[0] - actualWidth, 0,
                            -accum + widths[0] - actualWidth + space),
                        new Vector3(accum * 2 + deadZone + widths[i] - space + widths[0], thin, actualWidth - space));

                //верхний вход в обход мертвой зоны
                CreateCube(new Vector3(accum - deadZone - widths[0] - actionZoneWidth, 0, actionZoneHeigth),
                    new Vector3(actualWidth - space, thin, actionZoneWidth - accum - delta));

                //нижний обход мертвой зоны
                CreateCube(
                    new Vector3(-accum - deadZone - actualWidth * 2 + delta - widths[0], 0, actionZoneHeigth + accum),
                    new Vector3(2 * accum + deadZone + actualWidth * 3 - space - delta + widths[0], thin,
                        actualWidth - space));

                accum += widths[
                    i]; // - ( 2 * space * (actionZoneWidth - accum) / actionZoneWidth - space) - space * (-Mathf.Pow((accum/17.2f - 0.5f),2) * 2);
            }

            var models = new List<ProBuilderMesh>();

            foreach (var obj in _gameObjects)
            {
                models.Add(obj.GetComponent<ProBuilderMesh>());
            }

            var combineResult = CombineMeshes.Combine(models);

            foreach (var obj in _gameObjects)
            {
                GameObject.DestroyImmediate(obj);
            }

            _gameObjects.Clear();
            foreach (var mesh in combineResult)
            {
                _gameObjects.Add(mesh.gameObject);
            }

            string path = EditorUtility.SaveFilePanel("Save STL", "", "mesh","stl");
            if (!string.IsNullOrEmpty(path))
            {
                if(!pb_Stl_Exporter.Export(path, _gameObjects.ToArray(), FileType.Binary))
                {
                    EditorUtility.DisplayDialog("Export Failed", "Export Failed", "Ok");
                }
            }
        }

        [MenuItem("RibbonSolver/Clear")]
        private static void Clear()
        {
            foreach (var gameObject in _gameObjects)
            {
                GameObject.DestroyImmediate(gameObject);
            }
            _gameObjects.Clear();
        }

        private static GameObject CreateCube(Vector3 transformPosition, Vector3 sizes)
        {
            var meshInstance = ShapeGenerator.GenerateCube(PivotLocation.FirstCorner,
                sizes);
            meshInstance.unwrapParameters = new UnwrapParameters();
            var obj = meshInstance.gameObject;
            obj.transform.position = transformPosition;
            obj.GetComponent<MeshRenderer>().materials[0] = _meshRenderer.sharedMaterial;
            _gameObjects.Add(obj);
            return obj;
        }

        private static float GetS()
        {
            float s = 0;
            for (float i = 0; i < 1; i += 0.0001f)
            {
                s += GetWidth(i) * 0.0001f;
            }

            return s;
        }

        private static float GetRangeS(float l, float r)
        {
            float s = 0;
            for (float i = l; i < r; i += 0.0001f)
            {
                s += GetWidth(i) * 0.0001f;
            }

            return s;
        }

        private static float GetWidth(float l)
        {
            return Mathf.Pow(Mathf.Abs(2 * l - 1), 3) * 1.125f + 0.5f;
        }

        private static Mesh AddCube(Vector3 pos, Vector3 size)
        {
            return SetCube(Matrix4x4.TRS(pos, Quaternion.identity, size));
        }

        private static Mesh AddCube(Vector3 pos, Quaternion rot, Vector3 size)
        {
            return SetCube(Matrix4x4.TRS(pos, rot, size));
        }

        private static Mesh SetCube(Matrix4x4 transformation)
        {
            return TransformMesh(_cube, transformation);
        }

        private static Mesh TransformMesh(Mesh origin, Matrix4x4 transformation)
        {
            var mesh = new Mesh();
            var meshVertices = new Vector3[origin.vertices.Length];
            int i = 0;
            foreach (var vec in origin.vertices)
            {
                var meshVertex = transformation.MultiplyPoint(vec) + new Vector3(0.5f, 0.5f, 0.5f);
                meshVertices[i] = meshVertex;
                i++;
            }

            mesh.vertices = meshVertices;

            var indices = origin.GetIndices(0);
            mesh.SetIndices(indices, origin.GetTopology(0), 0);
            var triangles = origin.GetTriangles(0);
            mesh.SetTriangles(triangles, 0);
            var uvs = origin.uv;
            mesh.SetUVs(0, uvs, 0, uvs.Length);
            return mesh;
        }
    }
}
