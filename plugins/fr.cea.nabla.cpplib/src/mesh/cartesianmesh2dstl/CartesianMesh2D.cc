/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
	 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "../cartesianmesh2dstl/CartesianMesh2D.h"

#include <rapidjson/document.h>
#include <stdexcept>
#include <sstream>
#include <cassert>

void
CartesianMesh2D::jsonInit(const char* jsonContent)
{
	rapidjson::Document document;
	assert(!document.Parse(jsonContent).HasParseError());
	assert(document.IsObject());
	const rapidjson::Value::Object& o = document.GetObject();

	assert(o.HasMember("nbXQuads"));
	const rapidjson::Value& valueof_nbXQuads = o["nbXQuads"];
	assert(valueof_nbXQuads.IsInt());
	size_t nb_x_quads = valueof_nbXQuads.GetInt();

	assert(o.HasMember("nbYQuads"));
	const rapidjson::Value& valueof_nbYQuads = o["nbYQuads"];
	assert(valueof_nbYQuads.IsInt());
	size_t nb_y_quads = valueof_nbYQuads.GetInt();

	assert(o.HasMember("xSize"));
	const rapidjson::Value& valueof_xSize = o["xSize"];
	assert(valueof_xSize.IsDouble());
	double x_size = valueof_xSize.GetDouble();

	assert(o.HasMember("ySize"));
	const rapidjson::Value& valueof_ySize = o["ySize"];
	assert(valueof_ySize.IsDouble());
	double y_size = valueof_ySize.GetDouble();

	create(nb_x_quads, nb_y_quads, x_size, y_size);
}

const array<Id, 4>&
CartesianMesh2D::getNodesOfCell(const Id& cellId) const noexcept
{
	return m_geometry->getQuads()[cellId].getNodeIds();
}

const array<Id, 2>&
CartesianMesh2D::getNodesOfFace(const Id& faceId) const noexcept
{
	return m_geometry->getEdges()[faceId].getNodeIds();
}

Id
CartesianMesh2D::getFirstNodeOfFace(const Id& faceId) const noexcept
{
	return m_geometry->getEdges()[faceId].getNodeIds()[0];
}

Id
CartesianMesh2D::getSecondNodeOfFace(const Id& faceId) const noexcept
{
	return m_geometry->getEdges()[faceId].getNodeIds()[1];
}

vector<Id>
CartesianMesh2D::getCellsOfNode(const Id& nodeId) const noexcept
{
  vector<Id> cells;
  size_t i,j;
  tie(i, j) = id2IndexNode(nodeId);
  if (i < m_nb_y_quads && j < m_nb_x_quads) cells.emplace_back(index2IdCell(i, j));
  if (i < m_nb_y_quads && j > 0)            cells.emplace_back(index2IdCell(i, j-1));
  if (i > 0            && j < m_nb_x_quads) cells.emplace_back(index2IdCell(i-1, j));
  if (i > 0            && j > 0)            cells.emplace_back(index2IdCell(i-1, j-1));
  return cells;
}

vector<Id>
CartesianMesh2D::getCellsOfFace(const Id& faceId) const
{
	vector<Id> cells;	
	size_t i_f = static_cast<size_t>(faceId) / (2 * m_nb_x_quads + 1);
	size_t k_f = static_cast<size_t>(faceId) - i_f * (2 * m_nb_x_quads + 1);
	
	if (i_f < m_nb_y_quads) {  // all except upper bound faces
	  if (k_f == 2 * m_nb_x_quads) {  // right bound edge 
	    cells.emplace_back(index2IdCell(i_f, m_nb_x_quads-1));
	  }
    else if (k_f == 1) {  // left bound edge
	    cells.emplace_back(index2IdCell(i_f, 0));
	  }
	  else if (k_f % 2 == 0) {  // horizontal edge
	    if (i_f > 0)  // Not bottom bound edge
	      cells.emplace_back(index2IdCell(i_f-1, k_f/2));
	    cells.emplace_back(index2IdCell(i_f, k_f/2));
	  }
    else {  // vertical edge (neither left bound nor right bound)
	    cells.emplace_back(index2IdCell(i_f, (k_f-1)/2 - 1));
	    cells.emplace_back(index2IdCell(i_f, (k_f-1)/2));
	  }
	} else {  // upper bound faces
	  cells.emplace_back(index2IdCell(i_f-1, k_f));
	}
  return cells;
}

vector<Id>
CartesianMesh2D::getNeighbourCells(const Id& cellId) const
{
  std::vector<Id> neighbours;
  size_t i,j;
  tie(i, j) = id2IndexCell(cellId);
  if (i >= 1) neighbours.emplace_back(index2IdCell(i-1, j));
  if (i < m_nb_y_quads-1) neighbours.emplace_back(index2IdCell(i+1, j));
  if (j >= 1) neighbours.emplace_back(index2IdCell(i, j-1));
  if (j < m_nb_x_quads-1) neighbours.emplace_back(index2IdCell(i, j+1));
  return neighbours;
}

vector<Id>
CartesianMesh2D::getFacesOfCell(const Id& cellId) const
{
  size_t i,j;
  tie(i, j) = id2IndexCell(cellId);
  Id bottom_face(static_cast<Id>(2 * j + i * (2 * m_nb_x_quads + 1)));
  Id left_face(bottom_face + 1);
  Id right_face(bottom_face + static_cast<Id>(j == m_nb_x_quads-1 ? 2 : 3));
  Id top_face(bottom_face + static_cast<Id>(i < m_nb_y_quads-1 ? 2 * m_nb_x_quads + 1 : 2 * m_nb_x_quads + 1 - j));
  return vector<Id>({bottom_face, left_face, right_face, top_face});
}

Id
CartesianMesh2D::getCommonFace(const Id& cellId1, const Id& cellId2) const
{
	auto cell1Faces{getFacesOfCell(cellId1)};
	auto cell2Faces{getFacesOfCell(cellId2)};
	auto result = find_first_of(cell1Faces.begin(), cell1Faces.end(), cell2Faces.begin(), cell2Faces.end());
	if (result == cell1Faces.end()) {
    stringstream msg;
    msg << "No common faces found between cell " << cellId1 << " and cell " << cellId2 << endl;
	  throw runtime_error(msg.str());
	} else {
	  return *result;
  }
}

Id
CartesianMesh2D::getBackCell(const Id& faceId) const
{
  vector<Id> cells(getCellsOfFace(faceId));
  if (cells.size() < 2) {
    stringstream msg;
    msg << "Error in getBackCell(" << faceId << "): please consider using this method with inner face only." << endl;
	  throw runtime_error(msg.str());
  } else {
    return cells[0];
  }
}

Id
CartesianMesh2D::getFrontCell(const Id& faceId) const
{
  vector<Id> cells(getCellsOfFace(faceId));
  if (cells.size() < 2) {
    stringstream msg;
    msg << "Error in getFrontCell(" << faceId << "): please consider using this method with inner face only." << endl;
	  throw runtime_error(msg.str());
  } else {
    return cells[1];
  }
}

size_t
CartesianMesh2D::getNbCommonIds(const vector<Id>& as, const vector<Id>& bs) const noexcept
{
  size_t nbCommonIds = 0;
  for (auto a : as)
    for (auto b : bs)
      if (a == b) nbCommonIds++;
  return nbCommonIds;
}

bool
CartesianMesh2D::isInnerEdge(const Edge& e) const noexcept
{
  size_t i1, i2, j1, j2;
  tie(i1, j1) = id2IndexNode(e.getNodeIds()[0]);
  tie(i2, j2) = id2IndexNode(e.getNodeIds()[1]);
  // If nodes are located on the same boundary, then the face is an outer one
  if ((i1 == 0 && i2 == 0) || (i1 == m_nb_y_quads && i2 == m_nb_y_quads) ||
      (j1 == 0 && j2 == 0) || (j1 == m_nb_x_quads && j2 == m_nb_x_quads))
    return false;
  // else it's an inner one
  return true;
}

bool
CartesianMesh2D::isVerticalEdge(const Edge& e) const noexcept
{
  return (e.getNodeIds()[0] == e.getNodeIds()[1] + m_nb_x_quads + 1 ||
          e.getNodeIds()[1] == e.getNodeIds()[0] + m_nb_x_quads + 1);
}

bool
CartesianMesh2D::isHorizontalEdge(const Edge& e) const noexcept
{
  return (e.getNodeIds()[0] == e.getNodeIds()[1] + 1 ||
          e.getNodeIds()[1] == e.getNodeIds()[0] + 1);
}

bool
CartesianMesh2D::isInnerVerticalEdge(const Edge& e) const noexcept
{
  return isInnerEdge(e) && isVerticalEdge(e);
}

bool
CartesianMesh2D::isInnerHorizontalEdge(const Edge& e) const noexcept
{
  return isInnerEdge(e) && isHorizontalEdge(e);
}

Id
CartesianMesh2D::getBottomFaceOfCell(const Id& cellId) const noexcept
{
  size_t i,j;
  tie(i, j) = id2IndexCell(cellId);
  Id bottom_face(static_cast<Id>(2 * j + i * (2 * m_nb_x_quads + 1)));
  return bottom_face;
}

Id
CartesianMesh2D::getLeftFaceOfCell(const Id& cellId) const noexcept
{
  Id left_face(getBottomFaceOfCell(cellId) + 1);
  return left_face;
}

Id
CartesianMesh2D::getRightFaceOfCell(const Id& cellId) const noexcept
{
  size_t i,j;
  tie(i, j) = id2IndexCell(cellId);
  Id bottom_face(static_cast<Id>(2 * j + i * (2 * m_nb_x_quads + 1)));
  Id right_face(bottom_face + static_cast<Id>(j == m_nb_x_quads - 1 ? 2 : 3));
  return right_face;
}

Id
CartesianMesh2D::getTopFaceOfCell(const Id& cellId) const noexcept
{
  size_t i,j;
  tie(i, j) = id2IndexCell(cellId);
  Id bottom_face(static_cast<Id>(2 * j + i * (2 * m_nb_x_quads + 1)));
  Id top_face(bottom_face + static_cast<Id>(i < m_nb_y_quads - 1 ? 2 * m_nb_x_quads + 1 : 2 * m_nb_x_quads + 1 - j));
  return top_face;
}

Id
CartesianMesh2D::getTopCell(const Id& cellId) const noexcept
{
  size_t i,j;
  tie(i, j) = id2IndexCell(cellId);
  if (i == m_nb_y_quads-1) return cellId;
  return index2IdCell(i+1, j);
}

Id
CartesianMesh2D::getBottomCell(const Id& cellId) const noexcept
{
  size_t i,j;
  tie(i, j) = id2IndexCell(cellId);
  if (i==0) return cellId;
  return index2IdCell(i-1, j);
}

Id
CartesianMesh2D::getLeftCell(const Id& cellId) const noexcept
{
  size_t i,j;
  tie(i, j) = id2IndexCell(cellId);
  if (j==0) return cellId;
  return index2IdCell(i, j-1);
}
 
Id
CartesianMesh2D::getRightCell(const Id& cellId) const noexcept
{
  size_t i,j;
  tie(i, j) = id2IndexCell(cellId);
  if (j == m_nb_x_quads-1)  return cellId;
  return index2IdCell(i, j+1);
}

  /*
   * Definitions for later functions:
   * 
   *            |-27-|-28-|-29-|-30-|
   *           19   21   23   25   26
   *            |-18-|-20-|-22-|-24-|
   *           10   12   14   16   17
   *            |--9-|-11-|-13-|-15-|
   *            1    3    5    7    8
   *            |-0--|-2--|-4--|-6--|
   * 
   * E.g. with face number 14: (i.e. vertical face)
   *      - Bottom Face = 5
   *      - Bottom Left Face = 11
   *      - Bottom Right Face = 13
   *      - Top Face = 23
   *      - Top Left Face = 20
   *      - Top Right Face = 22
   *      - Left Face = 12
   *      - Right Face = 16
   * 
   * E.g. with face number 13: (i.e. horizontal face)
   *      - Bottom Face = 4
   *      - Bottom Left Face = 5
   *      - Bottom Right Face = 7
   *      - Top Face = 22
   *      - Top Left Face = 14
   *      - Top Right Face = 16
   *      - Left Face = 11
   *      - Right Face = 15
   */


Id CartesianMesh2D::getBottomFaceNeighbour(const Id& faceId) const
{
  const Edge& face(m_geometry->getEdges()[faceId]);
  assert(isInnerEdge(face));
  return (faceId - (2 * m_nb_x_quads + 1));
}

Id CartesianMesh2D::getBottomLeftFaceNeighbour(const Id& faceId) const
{
  const Edge& face(m_geometry->getEdges()[faceId]);
  assert(isInnerEdge(face));
  if (isVerticalEdge(face))
    return (faceId - 3);
  else  // horizontal
    return ((faceId + 1) - (2 * m_nb_x_quads + 1));
}

Id CartesianMesh2D::getBottomRightFaceNeighbour(const Id& faceId) const
{
  const Edge& face(m_geometry->getEdges()[faceId]);
  assert(isInnerEdge(face));
  if (isVerticalEdge(face))
    return (faceId - 1);
  else  // horizontal
    return ((faceId + 3) - (2 * m_nb_x_quads + 1));
}

Id CartesianMesh2D::getTopFaceNeighbour(const Id& faceId) const
{
  const Edge& face(m_geometry->getEdges()[faceId]);
  assert(isInnerEdge(face));
  return (faceId + (2 * m_nb_x_quads + 1));
}

Id CartesianMesh2D::getTopLeftFaceNeighbour(const Id& faceId) const
{
  const Edge& face(m_geometry->getEdges()[faceId]);
  assert(isInnerEdge(face));
  if (isVerticalEdge(face))
    return ((faceId - 3) + (2 * m_nb_x_quads + 1));
  else  // horizontal
    return (faceId + 1);
}

Id CartesianMesh2D::getTopRightFaceNeighbour(const Id& faceId) const
{
  const Edge& face(m_geometry->getEdges()[faceId]);
  assert(isInnerEdge(face));
  if (isVerticalEdge(face))
    return ((faceId - 1) + (2 * m_nb_x_quads + 1));
  else  // horizontal
    return (faceId + 3);
}

Id CartesianMesh2D::getRightFaceNeighbour(const Id& faceId) const
{
  const Edge& face(m_geometry->getEdges()[faceId]);
  assert(isInnerEdge(face));
  return (faceId + 2);
}

Id CartesianMesh2D::getLeftFaceNeighbour(const Id& faceId) const
{
  const Edge& face(m_geometry->getEdges()[faceId]);
  assert(isInnerEdge(face));
  return (faceId - 2);
}

Id
CartesianMesh2D::index2IdCell(const size_t& i, const size_t& j) const noexcept
{
  return static_cast<Id>(i * m_nb_x_quads + j);
}

pair<size_t, size_t>
CartesianMesh2D::id2IndexCell(const Id& k) const noexcept
{
  size_t i(static_cast<size_t>(k) / m_nb_x_quads);
  size_t j(static_cast<size_t>(k) - i * m_nb_x_quads);
  return make_pair(i, j);
}

Id
CartesianMesh2D::index2IdNode(const size_t& i, const size_t&j) const noexcept
{
  return static_cast<Id>(i * (m_nb_x_quads + 1) + j);
}

pair<size_t, size_t>
CartesianMesh2D::id2IndexNode(const Id& k) const noexcept
{
  size_t i(static_cast<size_t>(k) / (m_nb_x_quads + 1));
  size_t j(static_cast<size_t>(k) - i * (m_nb_x_quads + 1));
  return make_pair(i, j); 
}

vector<Id>
CartesianMesh2D::cellsOfNodeCollection(const vector<Id>& nodes)
{
  vector<Id> cells(0);
  for (auto&& node_id : nodes)
    for (auto&& cell_id : getCellsOfNode(node_id))
      cells.emplace_back(cell_id);
  // Deleting duplicates
  std::sort(cells.begin(), cells.end());
  cells.erase(std::unique(cells.begin(), cells.end()), cells.end());
  return cells;
}

void
CartesianMesh2D::create(size_t nb_x_quads, size_t nb_y_quads, double x_size, double y_size)
{
	m_nb_x_quads = nb_x_quads;
	m_nb_y_quads = nb_y_quads;

	vector<RealArray1D<2>> nodes_((nb_x_quads + 1) * (nb_y_quads + 1));
	vector<Quad> quads_(nb_x_quads * nb_y_quads);
	vector<Edge> edges_(2 * quads_.size() + nb_x_quads + nb_y_quads);

	vector<Id> outer_nodes_(2 * (nb_x_quads + nb_y_quads));
	m_inner_nodes.resize(nodes_.size() - outer_nodes_.size());
	m_top_nodes.resize(nb_x_quads + 1);
	m_bottom_nodes.resize(nb_x_quads + 1);
	m_left_nodes.resize(nb_y_quads + 1);
	m_right_nodes.resize(nb_y_quads + 1);

	size_t nb_inner_cells(nb_x_quads>1&&nb_y_quads>1?(nb_x_quads-2)*(nb_y_quads-2):0);  // 0 for mesh with only 1 cell
	size_t nb_outer_cells(nb_x_quads * nb_y_quads - nb_inner_cells);
	m_inner_cells.resize(nb_inner_cells);
	m_outer_cells.resize(nb_outer_cells);

	// node creation
	Id node_id_(0);
	Id inner_node_id_(0);
	Id top_node_id_(0);
	Id bottom_node_id_(0);
	Id left_node_id_(0);
	Id right_node_id_(0);

	for(size_t j(0); j <= nb_y_quads; ++j)
	{
		for(size_t i(0); i <= nb_x_quads; ++i)
		{
			nodes_[node_id_] = RealArray1D<2>{{x_size * i, y_size * j}};
			if (i!=0 && j!=0 && i!=nb_x_quads && j!=nb_y_quads)
				m_inner_nodes[inner_node_id_++] = node_id_;
			else
			{
				if (j==0) m_bottom_nodes[bottom_node_id_++] = node_id_;
				if (j==nb_y_quads) m_top_nodes[top_node_id_++] = node_id_;
				if (i==0) m_left_nodes[left_node_id_++] = node_id_;
				if (i==nb_x_quads) m_right_nodes[right_node_id_++] = node_id_;
				if (i==0 && j==0) m_bottom_left_node = node_id_;
				if (i==nb_x_quads && j==0) m_bottom_right_node = node_id_;
				if (i==0 && j==nb_y_quads) m_top_left_node = node_id_;
				if (i==nb_x_quads && j==nb_y_quads) m_top_right_node = node_id_;
			}
			++node_id_;
		}
	}

	// edge creation
	const size_t nb_x_nodes_(nb_x_quads + 1);
	Id edge_id_(0);
	for(size_t i(0); i < nodes_.size(); ++i)
	{
		const size_t right_node_index_(i + 1);
		if (right_node_index_ % nb_x_nodes_ != 0)
			edges_[edge_id_++] = move(Edge(static_cast<Id>(i), right_node_index_));
		const size_t above_node_index_(i + nb_x_nodes_);
		if (above_node_index_ < nodes_.size())
			edges_[edge_id_++] = Edge(static_cast<Id>(i), above_node_index_);
	}

	// quad creation
	Id quad_id_(0);
	Id inner_id_(0);
	Id outer_id_(0);
	for(size_t j(0); j < nb_y_quads; ++j)
	{
		for(size_t i(0); i < nb_x_quads; ++i)
		{
			if( (i != 0) && (i != nb_x_quads - 1) && (j != 0) && (j!= nb_y_quads - 1) )
			{
				m_inner_cells[inner_id_++] = quad_id_;
			}
			else
			{
				m_outer_cells[outer_id_++] = quad_id_;
			}
			const size_t upper_left_node_index_((j * static_cast<size_t>(nb_x_nodes_)) + i);
			const size_t lower_left_node_index_(upper_left_node_index_ + static_cast<size_t>(nb_x_nodes_));
			quads_[quad_id_++] = move(Quad(upper_left_node_index_, upper_left_node_index_ + 1,
                                     lower_left_node_index_ + 1, lower_left_node_index_));
		}
	}

	m_geometry = new MeshGeometry<2>(nodes_, edges_, quads_);

	// faces partitionment
	for (size_t edgeId(0); edgeId < edges_.size(); ++edgeId)
	{
		m_faces.emplace_back(edgeId);
		// Top boundary faces
		if (edgeId >= 2 * m_nb_x_quads * m_nb_y_quads + m_nb_y_quads) m_top_faces.emplace_back(edgeId);
		// Bottom boundary faces
		if ((edgeId < 2 * m_nb_x_quads) && (edgeId % 2 == 0)) m_bottom_faces.emplace_back(edgeId);
		// Left boundary faces
		if ((edgeId % (2 * m_nb_x_quads + 1) == 1) &&  (edgeId < (2 * m_nb_x_quads + 1) * m_nb_y_quads)) m_left_faces.emplace_back(edgeId);
		// Right boundary faces
		if (edgeId % (2 * m_nb_x_quads + 1) == 2 * m_nb_x_quads) m_right_faces.emplace_back(edgeId);
		// Outer Faces
		if (!isInnerEdge(edges_[edgeId]))
			m_outer_faces.emplace_back(edgeId);
		else
			m_inner_faces.emplace_back(edgeId);

		if (isVerticalEdge(edges_[edgeId]))
			m_inner_vertical_faces.emplace_back(edgeId);
		else if (isHorizontalEdge(edges_[edgeId]))
			m_inner_horizontal_faces.emplace_back(edgeId);
		else
		{
			stringstream msg;
			msg << "The inner edge " << edgeId << " should be either vertical or horizontal" << endl;
			throw runtime_error(msg.str());
		}
	}

	// Construction of boundary cell sets
	const auto& cells = m_geometry->getQuads();
	for (size_t cellId(0); cellId < cells.size(); ++cellId)
	{
		size_t i,j;
		tie(i, j) = id2IndexCell(cellId);
		// Top boundary cells
		if (i == m_nb_y_quads - 1) m_top_cells.emplace_back(cellId);
		// Bottom boundary cells
		if (i == 0) m_bottom_cells.emplace_back(cellId);
		// Left boundary cells
		if (j == 0) m_left_cells.emplace_back(cellId);
		// Right boundary cells
		if (j == m_nb_x_quads - 1) m_right_cells.emplace_back(cellId);
	}
}

